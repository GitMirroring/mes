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

struct S
{
  char a;
  struct {char b; char c;};
  char d;
  struct {char e;};
};

int
main ()
{
  struct S s = {'a', {'b', 'c'}, 'd'};
  return s.a != 'a' || s.b != 'b' || s.c != 'c' || s.d != 'd' || s.e != 0;
}
