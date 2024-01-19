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

/* command line options */
struct opt_s
{
  long sectors;                 /* block device sector count                 */
  size_t sector_size;           /* block device sector size                  */
  size_t chunk_size;            /* how big bufsize should be                 */
  unsigned char custom_byte;    /* custom overwrite byte                     */
  unsigned int verbose:2;       /* verbose level                             */
  unsigned int recursion:1;     /* traverse directories                      */
  unsigned int until_full:1;    /* write until out of space                  */
  unsigned int zero:1;          /* zero-out file                             */
  unsigned int lock:1;          /* lock files                                */
  unsigned int force:1;         /* force wipes -- override interaction       */
  unsigned int delete:1;        /* remove targets                            */
  unsigned int rmspcl:1;        /* remove special files (except blkdevs)     */
  unsigned int custom:1;        /* wipe file with user specified byte        */
  unsigned int random:1;        /* perform random passes                     */
  unsigned int statics:1;       /* perform static passes                     */
  unsigned int seclevel:2;      /* secure level                              */
  unsigned int interactive:1;   /* prompt for each file                      */
  unsigned int random_loop:5;   /* how many times to loop the random passes  */
  unsigned int wipe_multiply:5; /* how many times to loop all 35 passes      */
};

public int main(int argc, char **argv);
