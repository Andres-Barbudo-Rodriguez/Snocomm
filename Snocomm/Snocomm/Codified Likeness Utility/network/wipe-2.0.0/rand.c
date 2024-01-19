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

#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "std.h"
#include "io.h"
#include "mt.h"
#include "main.h"
#include "rand.h"

extern char *argvzero;
extern int errno, exit_code;
extern struct opt_s options;

int entropyfd;
char entropy_name[13]; /* for do_read error reporting */

/*
  rand_init -- inits the entropy source file descriptor
*/

public int rand_init(void)
{
  /* try /dev/urandom first; if that fails, try /dev/random */
  if ((entropyfd = open("/dev/urandom", O_RDONLY)) < 0)
    {
      if ((entropyfd = open("/dev/random", O_RDONLY)) < 0)
	{
	  fprintf(stderr, "\r%s: cannot open entropy source: %s\n",
		  argvzero, strerror(errno));
	  exit(1);
	}
      else
	{
	  strncpy(entropy_name, "/dev/random", sizeof(entropy_name));
	  fprintf(stderr, "\r%s: warning: cannot open /dev/urandom, "
		  "using /dev/random instead\n", argvzero);
	}
    }
  else
    strncpy(entropy_name, "/dev/urandom", sizeof(entropy_name));

  /* only seed once, else it's done in the random passes in wipe.c */
  if (options.seclevel == 0)
    if (prng_seed())
      return FAILED;

  return 0;
}

/*** the following functions are PRNG dependent ***/

/*
  prng_seed -- init seed
*/

public int prng_seed(void)
{
  urand_t seed;

  if (do_read(entropy_name, entropyfd, &seed, sizeof(prng_seed)))
    return FAILED;

  seedMT(seed);
  return 0;
}

/*
  prng_get_urand -- return urand_t PRN
*/

public urand_t prng_get_urand(void)
{
  return randomMT();
}

/*
  prng_fillbuf -- fills a buffer with pseudo-random values
                  the buffer must be urand_t aligned and
		  must be size + sizeof(urand_t) in length
*/

public void prng_fillbuf(const int seclevel, urand_t *buf, const size_t size)
{
  int i, ii;
  size_t c;
  urand_t urand;
  unsigned char *cbuf, *urandp;

  i=0; c = size - (size % sizeof(urand_t));
  ii = c / sizeof(urand_t);

  while (i < ii)
    buf[i++] = randomMT();

  urand = randomMT();
  cbuf = (unsigned char *) ((void *) buf + c);
  urandp = (unsigned char *) &urand;

  i=0; ii = size - c;

  while (i < ii)
    cbuf[i] = urandp[i++];
}
