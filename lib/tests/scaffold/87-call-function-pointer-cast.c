/* -*-comment-start: "//";comment-end:""-*-
 * GNU Mes --- Maxwell Equations of Software
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

int
f (int i)
{
  return i;
}

int
main ()
{
  int (*p) (int) = f;
  int (**q) (int) = &p;
  return ((int (*) (int)) (*p)) (7) != 7
           || ((int(*) (int)) (*q)) (7) != 7
           || ((int(*) (int)) (*f)) (7) !=7
           || ((int(*) (int)) f) (7) !=7;
}
