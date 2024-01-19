/*
  Licensed under the GNU Public License.
  Copyright (C) 1998-2001 by Thomas M. Vier, Jr. All Rights Reserved.

  wipe is free software.
  See LICENSE for more information.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include <unistd.h>
#include <stdio.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>

#define __USE_GNU
#include <string.h>

#include "config.h"

#ifndef HAVE_RMDIR
# define rmdir(x) remove(x)
#endif

#include "std.h"
#include "str.h"
#include "main.h"
#include "percent.h"
#include "file.h"
#include "dir.h"

extern int errno;
extern int exit_code;
extern char *argvzero;
extern struct opt_s options;

/*
  drill_down -- drill down through a directory

  char str[]  --  directory name
*/

public void drill_down(const char str[])
{
  DIR *dir;
  struct dirent *entry;
  char *base, dirname[PATH_MAX+1];
  size_t len;
  char prompt[4];

  /* copy str to dirname, so we can write to it */
  strncpy(dirname, str, PATH_MAX);
  dirname[sizeof(dirname)-1] = 0; /* term str */

#ifdef DEBUG
  fprintf(stderr, "checking %s\n", dirname);
#endif

  if ((dir = opendir(dirname)) == NULL)
    {
      fprintf(stderr, "\r%s: cannot open directory `%s': %s\n",
	      argvzero, dirname, strerror(errno));
      exit_code = errno; return;
    }

  if (chdir(dirname))
    {
      fprintf(stderr, "\r%s: cannot enter directory `%s': %s\n",
	      argvzero, dirname, strerror(errno));
      closedir(dir); exit_code = errno; return;
    }

  while ((entry = readdir(dir)) != NULL)
    {
      if (strncmp(entry->d_name, ".", 2) && strncmp(entry->d_name, "..", 3) != 0)
	do_file(entry->d_name); /*** process file ***/
    }

  if (chdir(".."))
    {
      fprintf(stderr, "\r%s: cannot exit current directory `%s': %s\n"
	              "We're trapped!\n", argvzero, dirname, strerror(errno));
      abort();
    }

  closedir(dir);

#ifdef DEBUG
  if (options.delete)
    fprintf(stderr, "\rwould have removed: %s\n", dirname);
#endif

#ifndef DEBUG
  if (options.delete)
    {
      /*
	make sure dirname doesn't end in a slash,
	otherwise base will end up pointing to \0
      */
#ifdef HAVE_STRNLEN
      len = strnlen(dirname, PATH_MAX);
#else
      len = strlen(dirname);
      if (len > PATH_MAX) len = PATH_MAX;
#endif
      base = (char *) (dirname + (len-1)); /* find the last char */

      /* loop it, in case of multiple slashes */
      /* note that base is decremented after each use */
      while (strncmp((char *) base--, "/", 1) == 0)
	dirname[--len] = (char) 0; /* truncate string and update length */

      /*
	 point base at just after the path to the directory,
         since we're in the same directory that the target is.
         in other words, this strips the path the directory
      */
      if ((base = strrchr(dirname, '/')) == NULL)
	base = dirname;
      else
	++base;

      if (options.interactive)
	{
	  prompt[0] = 0; /* clear prompt */
	  while (prompt[0] != 'y' && prompt[0] != 'n')
	    {
	      printf("\r%s: remove directory `%s'? ",
		     argvzero, dirname);
	      fgets(prompt, sizeof(prompt), stdin);

	      if (prompt[0] == 'y' || prompt[0] == 'Y') goto removedir;
	      if (prompt[0] == 'n' || prompt[0] == 'N') return; /* skip to next file */

	      /* else, incorrect response -- re-prompt */
	    } /* while prompt */
	}

    removedir:
      if (rmdir(base))
	{
	  fprintf(stderr, "\r%s: %s: unable to remove directory: `%s'\n",
		  argvzero, strerror(errno), base);
	  exit_code = errno; return;
	}
    }
#endif
}

/*
  wipe_name -- rename to random characters

  there's not much sense in doing the wipe passes
  on the filename. let's just give it a random name.
*/

public int wipe_name(struct file_s *f)
{
  size_t len, pathlen;
  char *base, dest_name[PATH_MAX+1];

#ifdef SANITY
  if ((!options.random) || (!options.delete))
    {
      fprintf(stderr, "%s: options.random is %d, options.delete is %d\n",
	      argvzero, options.random, options.delete);
      abort();
    }
#endif

  /* make sure it's NUL-terminated */
  dest_name[sizeof(dest_name)-1] = 0;

  /* copy the path to the file */

  /*
    strncpy does NOT guarantee NUL termination - drill that into your head
    it's an often over looked hole for a buffer overflow exploit from
    untrusted input.
  */
  strncpy(dest_name, f->real_name, PATH_MAX);

  f->real_name[sizeof(f->real_name)-1] = 0;

  /* point base at just after the path, ie, strip the path */
  if ((base = strrchr(dest_name, '/')) == NULL)
    base = dest_name;
  else
    ++base;

  /* truncate the path to get the length */
  *base = 0x00;

  pathlen = strnlen(dest_name, PATH_MAX);

  /*
    we try to use as long a filename as possible,
    but not longer than PATH_MAX.
  */
  len = NAME_MAX;
  while (len + pathlen > PATH_MAX) --len;

  rename_str(base, len); /* get a random filename */

#ifdef NORENAME
  /* debugging aid */
  fprintf(stderr, "\rrenamed to %s\n", base);
  return 0;
#endif

  if (rename(f->real_name, dest_name) == 0)
    {
      /* update pathname */
      strncpy(f->real_name, dest_name, PATH_MAX);
      f->real_name[sizeof(f->real_name)-1] = 0;
    }
  else
    return FAILED;

  return 0;
}
