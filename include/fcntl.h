/* -*-comment-start: "//";comment-end:""-*-
 * GNU Mes --- Maxwell Equations of Software
 * Copyright © 2017 Jan (janneke) Nieuwenhuizen <janneke@gnu.org>
 * Copyright © 2021 W. J. van der Laan <laanwj@protonmail.com>
 * Copyright © 2023 Emily Trau <emily@downunderctf.com>
 * Copyright © 2025 Stefan <stefan-guix@vodafonemail.de>
 *
 * This file is part of GNU Mes.
 *
 * GNU Mes is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or (at
 * your option) any later version.
 *
 * GNU Mes is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with GNU Mes.  If not, see <http://www.gnu.org/licenses/>.
 */
#ifndef __MES_FCNTL_H
#define __MES_FCNTL_H 1

#if SYSTEM_LIBC
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#undef __MES_FCNTL_H
#include_next <fcntl.h>

#else // ! SYSTEM_LIBC

// *INDENT-OFF*
#if __linux__
#define O_RDONLY           0
#define O_WRONLY           1
#define O_RDWR             2
#define O_CREAT         0x40
#define O_EXCL          0x80
#define O_NOCTTY       0x100
#define O_TRUNC        0x200
#define O_APPEND       0x400
#define O_NONBLOCK     0x800
#define O_DSYNC       0x1000
#define O_ASYNC       0x2000
#define O_DIRECT      0x4000
#define O_LARGEFILE   0x8000
#define O_DIRECTORY  0x10000
#define O_NOFOLLOW   0x20000
#define O_NOATIME    0x40000
#define O_CLOEXEC    0x80000
#define O_SYNC      0x101000
#define O_PATH      0x200000
#define O_TMPFILE   0x410000
#define O_ACCMODE   (O_RDONLY|O_WRONLY|O_RDWR|O_PATH)
#define O_EXEC      O_PATH
#define O_NDELAY    O_NONBLOCK
#define O_READ      O_RDONLY
#define O_WRITE     O_WRONLY
#define O_RSYNC     O_SYNC
#define O_SEARCH    O_PATH
#define F_RDLCK     0
#define F_WRLCK     1
#define F_UNLCK     2
#if __SIZEOF_LONG__ == 8
  #define F_GETLK   5
  #define F_SETLK   6
  #define F_SETLKW  7
#else
  #define F_GETLK  12
  #define F_SETLK  13
  #define F_SETLKW 14
#endif
#if !__M2__
#include <sys/types.h>
struct flock
{
  short l_type;
  short l_whence;
  off_t l_start;
  off_t l_len;
  pid_t l_pid;
};
#endif

#ifdef __arm__
#define O_DIRECTORY   0x4000
#define O_TMPFILE   0x404000
#else
#define O_DIRECTORY  0x10000
#define O_TMPFILE   0x410000
#endif

#define AT_FDCWD            -100
#define AT_SYMLINK_NOFOLLOW  0x100
#define AT_REMOVEDIR         0x200

#elif __GNU__
#define	O_RDONLY	  1
#define	O_WRONLY	  2
#define	O_RDWR		  3
#define	O_CREAT	       0x10
#define	O_APPEND      0x100
#define	O_TRUNC	    0x10000
#else
#error platform not supported
#endif
// *INDENT-ON*

#define FD_CLOEXEC 1

#define F_DUPFD 0
#define F_GETFD 1
#define F_SETFD 2
#define F_GETFL 3
#define F_SETFL 4

#define creat(file_name, mode) open (file_name, O_WRONLY | O_CREAT | O_TRUNC, mode)
int dup (int old);
int dup2 (int old, int new);

#if !__M2__
int fcntl (int filedes, int command, ...);
int open (char const *s, int flags, ...);
#endif

#endif // ! SYSTEM_LIBC

#endif // __MES_FCNTL_H
