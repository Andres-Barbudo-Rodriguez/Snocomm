/*
  Licensed under the GNU Public License.
  Copyright (C) 1998-2001 by Thomas M. Vier, Jr. All Rights Reserved.

  wipe v2.0
  by Tom Vier <nester@users.sourceforge.net>

  http://wipe.sourceforge.net/

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
#include <stdlib.h>
#include <getopt.h>
#include <errno.h>

#include "config.h"
#include "require.h"

#include "std.h"
#include "percent.h"
#include "file.h"
#include "rand.h"
#include "text.h"
#include "main.h"

/* global vars */
char *argvzero;                       /* what wipe was called as, argv[0]        */
int exit_code = 0;                    /* final exit code for main()              */

extern int errno;

struct opt_s options;                 /* cmd line options                        */

public int main(int argc, char **argv)
{
  int opt;                            /* option character                        */
  long long tmp; int tmpd;            /* to check input range                    */
  extern int optopt;                  /* getopt() stuff                          */
  extern char *optarg;                /* getopt() stuff                          */
  extern int optind, opterr;          /* getopt() stuff                          */

  opterr = 0;                         /* we'll handle bad options                */

  errno = 0;
  argvzero = argv[0];

  /* set defaults */
  options.sectors               = 0;  /* initialize                              */
  options.sector_size = SECTOR_SIZE;  /* initialize                              */
  options.chunk_size   = CHUNK_SIZE;  /* initialize                              */
  options.custom_byte        = 0x00;  /* custom single byte pass                 */
  options.verbose               = 1;  /* show percent if >= PERCENT_ENABLE_SIZE  */
  options.recursion             = 0;  /* do not traverse directories             */
  options.until_full            = 0;  /* don't write until out of space          */
  options.zero                  = 0;  /* don't just zero-out the file            */
  options.force                 = 0;  /* respect file permissions                */
  options.delete                = 1;  /* remove targets                          */
  options.rmspcl                = 1;  /* unlink all special files except blkdevs */
  options.custom                = 0;  /* don't use a custom byte                 */
  options.random                = 1;  /* perform random passes                   */
  options.statics               = 1;  /* preform static passes                   */
  options.seclevel              = 1;  /* fast/secure mode                        */
  options.interactive           = 0;  /* don't confirm each file                 */
  options.random_loop       = 4 - 1;  /* default to four random passes           */
  options.wipe_multiply     = 1 - 1;  /* perform wipe loop once                  */

#ifdef SANITY
  /* sanity checks */
  if (sizeof(size_t) != sizeof(off_t))
    {
      printf("sizeof(size_t) != sizeof(off_t): file offsets are screwed!\n");
      abort();
    }
#endif

  while ((opt = getopt(argc, argv, "S:C:B:p:b:l::x::XucwsiIhHfFnNdDvVzZrRtTkKaA")) != -1)
    {
      switch (opt)
	{
	case 'B': /* sector count */
	  sscanf(optarg, "%lld", &tmp);

	  if (tmp < 1)
	    {
	      fprintf(stderr, "%s: bad option: sector count < 1\n",
		      argvzero);
	      exit(BAD_USAGE);
	    }

	  options.sectors = tmp;
	  break;

	case 'S': /* sector size */
	  sscanf(optarg, "%lld", &tmp);

	  if (tmp < 1)
	    {
	      fprintf(stderr, "%s: bad option: sector size < 1\n",
		      argvzero);
	      exit(BAD_USAGE);
	    }

	  options.sector_size = tmp;
	  break;

	case 'C': /* chunk size -- max buf size */
	  sscanf(optarg, "%lld", &tmp);

	  if (tmp < 1)
	    {
	      fprintf(stderr, "%s: bad option: block device buffer size < 1k\n",
		      argvzero);
	      exit(BAD_USAGE);
	    }

	  options.chunk_size = tmp << 10;
	  break;

	case 'p': /* wipe multiply */
	  sscanf(optarg, "%lld", &tmp);
	
	  if (tmp < 1)
	    {
	      fprintf(stderr, "%s: bad option: wipe multiply < 1\n",
		      argvzero);
	      exit(BAD_USAGE);
	    }

	  if (tmp > 32)
	    {
	      fprintf(stderr, "%s: bad option: wipe multiply > 32\n",
		      argvzero);
	      exit(BAD_USAGE);
	    }

	  options.wipe_multiply = tmp - 1;
	  break;

	case 'b':  /* overwrite file with byte */
	  sscanf(optarg, "%i", &tmpd);

	  if (tmpd < 0)
	    {
	      fprintf(stderr, "%s: bad option: wipe byte < 0\n", argvzero);
	      exit(BAD_USAGE);
	    }

	  if (tmpd > 255)
	    {
	      fprintf(stderr, "%s: bad option: wipe byte > 255\n", argvzero);
	      exit(BAD_USAGE);
	    }

	  options.custom = 1; options.custom_byte = tmpd;
	  break;

	case 'l':  /* set wipe secure level */
	  if (optarg == 0)
	    options.seclevel = 1;
	  else
	    {
	      sscanf(optarg, "%lld", &tmp);

	      if (tmp < 0 || tmp > 2)
		{
		  fprintf(stderr, "%s: bad option: secure level < 0 or > 2\n",
			  argvzero);
		  exit(BAD_USAGE);
		}

	      options.seclevel = tmp;
	    }
	  break;

	case 'x':  /* perform random passes */
	  if (optarg == 0)
	    options.random = 1;
	  else
	    {
	      tmp = atoi(optarg);

	      if (tmp < 0)
		{
		  fprintf(stderr, "%s: bad option: random loop < 0\n",
			  argvzero);
		  exit(BAD_USAGE);
		}

	      if (tmp > 32)
		{
		  fprintf(stderr, "%s: bad option: random loop > 32\n",
			  argvzero);
		  exit(BAD_USAGE);
		}

	      if (tmp == 0)
		options.random = 0;
	      else
		options.random_loop = tmp - 1;
	    }
	  break;

	case 'X':  /* don't perform random passes */
	  /* random and static passes can't both be disabled */
	  options.random = 0;
	  options.statics = 1;
	  break;

	case 'r':  /* recursion */
	case 'R':  /* some people are used to '-R' */
	  options.recursion = 1; /* enable recursion */
	  break;

	case 'i':  /* interactive -- disables force */
	  options.force = 0;
	  options.interactive = 1;
	  break;

	case 'I':  /* non-interactive */
	  options.interactive = 0;
	  break;

	case 'f':  /* force -- ignore permissions and override interaction */
	  options.force = 1;
	  options.interactive = 0;
	  break;

	case 'F':  /* disable force */
	  options.force = 0;
	  break;

	case 'n':  /* remove special files, except blkdevs */
	  options.rmspcl = 1;
	  break;

	case 'N':  /* skip special files */
	  options.rmspcl = 0;
	  break;

	case 'd':  /* delete targets */
	  options.delete = 1;
	  break;

	case 'D':  /* don't remove targets */
	  options.delete = 0;
	  break;

	case 'c':  /* copyright */
	  show_copyright(); exit(0);
	  break;

	case 'w':  /* warranty */
	  show_war(); exit(0);
	  break;

	case 'u':  /* usage */
	  usage(stdout); exit(0);
	  break;

	case 'h':  /* help */
	case 'H':  /* undocumented */
	  help(stdout); exit(0);
	  break;

	case 'v':  /* force verbose */
	  if (!options.until_full)
	    options.verbose = 2;
	  break;

	case 'V':  /* verbose */
	  if (!options.until_full)
	    options.verbose = 1;
	  break;

	case 's':  /* silent */
	  options.verbose = 0;
	  options.interactive = 0;
	  break;

	case 'z':  /* zero */
	  options.zero = 1;
	  break;

	case 'Z':  /* don't just zero */
	  options.zero = 0;
	  break;

	case 't':  /* enable static passes */
	  options.statics = 1;
	  break;

	case 'T':  /* disable static passes */
	  options.statics = 0;
	  /* random and static passes can't both be disabled */
	  if (!options.random)
	    options.random = 1;
	  break;

	case 'k': /* enable file locks */
	  options.lock = 1;
	  break;

	case 'K': /* disable file locks */
	  options.lock = 0;
	  break;

	case 'a': /* enable write until full */
	  options.until_full = 1;
	  options.verbose = 0; /* screws up percentage reporting */
	  break;

	case 'A': /* disable write until full */
	  options.until_full = 0;
	  break;

	default:
	  badopt(optopt);
	  break;
	}
    }

#ifdef OPTIONTEST
  printf("options are:\n");
  printf("sectors           = %ld\n", options.sectors);
  printf("sector_size       = %ld\n", options.sector_size);
  printf("chunk_size        = %ld\n", options.chunk_size);
  printf("verbose           = %d\n", options.verbose);
  printf("recursion         = %d\n", options.recursion);
  printf("until_full        = %d\n", options.until_full);
  printf("zero              = %d\n", options.zero);
  printf("force             = %d\n", options.force);
  printf("delete            = %d\n", options.delete);
  printf("rmspcl            = %d\n", options.rmspcl);
  printf("custom            = %d\n", options.custom);
  printf("custom_byte       = 0x%x\n", options.custom_byte);
  printf("random            = %d\n", options.random);
  printf("statics           = %d\n", options.statics);
  printf("seclevel          = %d\n", options.seclevel);
  printf("interactive       = %d\n", options.interactive);
  printf("random_loop       = %d\n", options.random_loop + 1);
  printf("wipe_multiply     = %d\n\n", options.wipe_multiply + 1);
#endif

#ifdef FILETEST
  fprintf(stderr, "getopt() parsed %d args\n", optind - 1);
#endif

  if (optind == argc)
    {
      show_copyright();
      fprintf(stderr, "\nType \'%s -u\' for usage.\n",
	      argvzero);
      exit(BAD_USAGE);
    }

  if (rand_init())
    {
      fprintf(stderr, "\r%s: rand_init(): fatal error\n", argvzero);
      exit(exit_code);
    }

  /* check access and wipe if ok */
  while (optind < argc) do_file(argv[optind++]); /*** parse files ***/

#ifdef FILETEST
  fprintf(stderr, "\n");
#endif

  percent_shutdown();

  return exit_code;
}
