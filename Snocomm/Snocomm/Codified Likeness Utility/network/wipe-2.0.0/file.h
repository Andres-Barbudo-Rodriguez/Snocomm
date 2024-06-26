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

/* this pre-processor stuff is for both file.c and dir.c to use */

#ifdef HAVE_DIRENT_H
# include <dirent.h>
# define NAMLEN(dirent) (strlen((dirent)->d_name))
#endif

#ifndef HAVE_DIRENT_H
# define dirent direct
# define NAMLEN(dirent) ((dirent)->d_namlen)
# ifdef HAVE_SYS_NDIR_H
#  include <sys/ndir.h>
# endif
# ifdef HAVE_SYS_DIR_H
#  include <sys/dir.h>
# endif
# ifdef HAVE_NDIR_H
#  include <ndir.h>
# endif
#endif

#ifndef PATH_MAX
# define PATH_MAX 4095
#endif

#ifndef NAME_MAX
# define NAME_MAX 1023
#endif

#ifndef O_NOFOLLOW
# define O_NOFOLLOW 0
#endif

#ifndef O_DSYNC
# define O_DSYNC O_SYNC
#endif

#ifdef HAVE_FSYNC
# define FSYNC
# define SYNC 0
# ifndef HAVE_FDATASYNC
#  define fdatasync(x) fsync(x)
# endif
#else
# undef FSYNC
# define SYNC O_DSYNC
#endif

#include <sys/stat.h>

/* file data */
struct file_s
{
  int fd;                       /* file descriptor                           */

  void *buf;                    /* file buffer -- 64bit aligned              */
  size_t bufsize;               /* requested buffer size from fsetbuf()      */

  size_t fsize;                 /* intended file length or block dev length  */
  long int loop, loopr;         /* fsize / bufsize and fsize % bufsize       */

  char name[PATH_MAX+1],        /* original pathname                         */
  real_name[PATH_MAX+1];        /* current filename -- path is the same      */

  struct stat st;               /* file status                               */
  struct percent_s percent;     /* percent data for the current file         */
};

public void do_file(const char *name);
public void fsetbuf(struct file_s *f);
public void ffreebuf(struct file_s *f);
public int fgetbuf(struct file_s *f);
