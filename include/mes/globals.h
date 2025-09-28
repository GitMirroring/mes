/* -*-comment-start: "//";comment-end:""-*-
 * GNU Mes --- Maxwell Equations of Software
 * Copyright © 2016,2017,2018,2019,2020,2021,2022,2025 Janneke Nieuwenhuizen <janneke@gnu.org>
 * Copyright © 2022 Timothy Sample <samplet@ngyro.com>
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

#ifndef __MES_GLOBALS_H
#define __MES_GLOBALS_H

/* mes */
extern char *g_datadir;
extern int g_debug;
extern char *g_buf;
extern int g_continuations;
extern struct scm *g_symbols;
extern struct scm *g_symbol_max;
extern int g_mini;

/* a/env */
extern struct scm *R0;
/* param 1 */
extern struct scm *R1;
/* save 2 */
extern struct scm *R2;
/* continuation */
extern struct scm *R3;
/* initial module obarray */
extern struct scm *M0;
/* current module */
extern struct scm *M1;
/* macro */
extern struct scm *g_macros;
extern struct scm *g_ports;

/* gc */
extern size_t ARENA_SIZE;
extern size_t MAX_ARENA_SIZE;
extern size_t STACK_SIZE;
extern size_t JAM_SIZE;
extern size_t GC_SAFETY;
extern size_t MAX_STRING;
extern char *g_arena;
extern struct scm *cell_arena;
extern struct scm *cell_zero;

extern struct scm *g_free;
extern struct scm *g_symbol;

extern struct scm **g_stack_array;
extern struct scm *g_cells;
extern struct scm *g_news;
extern long g_stack;
extern size_t gc_count;
extern struct timespec *gc_start_time;
extern struct timespec *gc_end_time;
extern size_t gc_time;

extern char **__execl_c_argv;
extern char **__execle_c_env;
extern char *__open_boot_buf;
extern char *__open_boot_file_name;
extern char *__setenv_buf;
extern char *__reader_read_char_buf;
extern struct timespec *g_start_time;
extern struct timeval *__gettimeofday_time;
extern struct timespec *__get_internal_run_time_ts;
extern struct utsname *__uts;

extern struct scm *scm_hash_table_type;
extern struct scm *scm_variable_type;

#endif /* __MES_GLOBALS_H */
