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

#include "config.h"
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>

#define __USE_GNU
#include <string.h>

#include "std.h"
#include "main.h"
#include "percent.h"
#include "file.h"

extern struct opt_s options;

char p_reported;
size_t oldpathlen, lastpathlen, lastpathlen;

private void percent_line_clear(struct percent_s *p);

/*
  percent_init -- initialize percent data
*/

public void percent_init(struct percent_s *p, const char *name, const size_t bufsize, const long int loop)
{
  int total_passes = STATIC_PASSES;

  if (!options.verbose)
    return;

  p->name = (char *) name;
  p->nlen = strnlen(name, PATH_MAX);

  if (options.random)
    /* two random loops per wipe loop, so multiply it by 2 */
    total_passes += (options.random_loop + 1) * 2;

  p->complete = 0; /* initialize */
  p->display = 0;

  if (options.verbose == 1 && bufsize >= PERCENT_ENABLE_SIZE)
    p->display = 1; /* enable percentage reporting */

  if (options.verbose == 2) /* force percentage reporting */
    {
      p->display = 1; p->complete = 0;
    }

  p->increment = (100.0 / total_passes) / (options.wipe_multiply + 1);

  if (loop)
    {
      /* percent_update() should be called after each loop */
      p->increment /= loop;
      /* percent reporting will have an error margin of +/- chunk_size */
    }

  percent_line_clear(p);
  printf(" \r%s: 0%%", name); fflush(stdout); /* display */
}

/*
  percent_line_clear -- clear line
*/

private void percent_line_clear(struct percent_s *p)
{
  char spaces[PATH_MAX+1];

  if (oldpathlen)
    {
      //printf("pathlen == %d\noldpathlen == %d\n", strnlen(pathname, PATH_MAX), oldpathlen);
      memset(spaces, (char) 0x20, oldpathlen);

      spaces[oldpathlen+1] = (char) 0x00;
      printf("\r%s       \r", spaces);
    }

  oldpathlen = p->nlen;
}

/*
  percent_update -- update and display progress
*/

public void percent_update(struct percent_s *p)
{
  p->complete += p->increment;

#ifdef SANITY
  if (p->complete > 120)
    {
      printf("\rp->complete == %d\n", (int) p->complete); fflush(stdout);
      abort();
    }
#endif

  printf(" \r%s: %d%%", p->name, (int) (p->complete)); fflush(stdout);
}

/*
  percent_done -- called between percent_init()s after reporting
*/

public void percent_done(struct percent_s *p)
{
  lastpathlen = p->nlen;

  if (!p->display)
    return;

  p_reported = 1;

  /*
     sometimes a double isn't enough decimals to accurately hold
     p->increment, so we explicitly print 100% completion.
     otherwise we might end up with (int) p->complete < 100;
     probably 98 or 99.
  */

  if (p->complete)
    {printf("\r%s: 100%%", p->name); fflush(stdout);}
}

/*
  percent_shutdown -- called by main(), after last percentage report
*/

public void percent_shutdown(void)
{
  char spaces[PATH_MAX+1];

#ifdef SANITY
  /* can be triggered, eg by lstat() failure when options.verbose > 0 */
  if (options.verbose && p_reported == 0)
    {
      fprintf(stderr, "\np_reported == %d\n", p_reported);
      abort();
    }
#endif

  if (p_reported)
    {
      //printf("pathlen == %d\noldpathlen == %d\n", strnlen(pathname, PATH_MAX), oldpathlen);
      memset(spaces, (char) 0x20, lastpathlen);

      spaces[lastpathlen+1] = (char) 0x00;
      printf("\r%s       \r", spaces);
    }
}
