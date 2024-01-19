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

#ifndef _POSIX_SYNCHRONIZED_IO
# define _POSIX_SYNCHRONIZED_IO
# include <unistd.h>
#endif

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "config.h"

#include "std.h"
#include "percent.h"
#include "file.h"
#include "wipe.h"
#include "main.h"
#include "io.h"

extern int errno;
extern int exit_code;
extern char *argvzero;
extern struct opt_s options;

/*
  do_fwb -- file write barrier
*/

public int do_fwb(const char name[], const int fd)
{
  return do_fsync(name, fd);
}

/*
  do_fsync -- sync file to disk
*/

public int do_fsync(const char name[], const int fd)
{
#ifndef FSYNC
  return 0;
#endif

  if (fdatasync(fd))
    {
      fprintf(stderr, "\r%s: cannot synchronize `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  return 0;
}

/*
  do_ftruncate -- ftruncate(2) wrapper
*/

public int do_ftruncate(const char name[], const int fd, off_t length)
{
  if (ftruncate(fd, length))
    {
      fprintf(stderr, "\r%s: cannot truncate `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  return 0;
}

/*
  do_close -- close(2) wrapper
*/

public int do_close(const char name[], const int fd)
{
  if (close(fd))
    {
      fprintf(stderr, "\r%s: close failed for `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  return 0;
}

/*
  do_read -- read(2) wrapper
*/

public int do_read(const char name[], const int fd, void *buf, size_t count)
{
  ssize_t c;
  int retries;

 retry:
  c = read(fd, buf, count);

  if (c == -1)
    {
      if (errno == EINTR)
	goto retry;

      if (errno == EIO)
	{
	  if (retries == 5)
	    goto abort;
	  else
	    {++retries; goto retry;}
	}

    abort:
      fprintf(stderr, "\r%s: cannot read `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  else
    {
      if (c < count)
	{
	  count -= c;
	  do_read(name, fd, (buf + c), count); /* recurse */
	}
    }

  return 0;
}

/*
  do_write -- write(2) wrapper
*/

public int do_write(const char name[], const int fd, void *buf, size_t count)
{
  ssize_t c;
  char retries;

 retry:
  c = write(fd, buf, count);

  if (c == -1)
    {
      if (errno == ENOSPC && options.until_full)
	return ENOSPC;

      if (errno == EIO || errno == EAGAIN || errno == EINTR)
	{
	  if (retries == 5)
	    goto abort;
	  else
	    {++retries; goto retry;}
	}

    abort:
      fprintf(stderr, "\r%s: cannot write `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  else
    {
      if (c < count)
	{
	  count -= c;
	  do_write(name, fd, (buf + c), count); /* recurse */
	}
    }

  return 0;
}

/*
  do_lseek -- lseek(2) wrapper
*/

public int do_lseek(const char name[], const int fd, const off_t offset, const int whence)
{
  if (lseek(fd, offset, whence) != offset)
    {
      fprintf(stderr, "\r%s: lseek() failed for `%s': %s\n",
	      argvzero, name, strerror(errno));
      exit_code = errno; return FAILED;
    }
  return 0;
}
