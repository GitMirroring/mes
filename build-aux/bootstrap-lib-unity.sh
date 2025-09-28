#! @SHELL@

# GNU Mes --- Maxwell Equations of Software
# Copyright © 2019,2020,2022,2025 Janneke Nieuwenhuizen <janneke@gnu.org>
# Copyright © 2023 Ekaitz Zarraga <ekaitz@elenq.tech>
# Copyright © 2023 Timothy Sample <samplet@ngyro.com>
#
# This file is part of GNU Mes.
#
# GNU Mes is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# GNU Mes is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GNU Mes.  If not, see <http://www.gnu.org/licenses/>.

archive=libmescc.a

base=$(basename $archive .a)
sources=$(eval echo '$'$(echo $base | sed s,+,_,)_SOURCES)
c=$base.c
(cd $srcdest && cat $sources) > $c
o=$base.o
if test ! -e $o -o $c -nt $o; then
    echo "  CC         $c"
    $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o $c
fi
objects=$o
echo "  AR         $mes_cpu-mes/$archive"
$AR crD $mes_cpu-mes/$archive $objects

archive=libc.a

base=$(basename $archive .a)
sources=$(eval echo '$'$(echo $base | sed s,+,_,)_SOURCES)
c=$base.c
(cd $srcdest && cat $sources) > $c
o=$base.o
if test ! -e $o -o $c -nt $o; then
    echo "  CC         $c"
    $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o $c
fi
objects=$o
echo "  AR         $mes_cpu-mes/$archive"
$AR crD $mes_cpu-mes/$archive $objects

cp $mes_cpu-mes/libc.a $mes_cpu-mes/libc-mini.a

archive=libc+tcc.a

base=$(basename $archive .a)
sources=$(eval echo '$'$(echo $base | sed s,+,_,)_SOURCES)
c=$base.c
(cd $srcdest && cat $sources) > $c
o=$base.o
if test ! -e $o -o $c -nt $o; then
    echo "  CC         $c"
    $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o $c
fi
objects=$o
echo "  AR         $mes_cpu-mes/$archive"
$AR crD $mes_cpu-mes/$archive $objects

cp $mes_cpu-mes/libc+tcc.a $mes_cpu-mes/libc+gnu.a

AM_CPPFLAGS="$AM_CPPFLAGS -I ${srcdest}src"
archive=mes.a

base=$(basename $archive .a)
sources=$(eval echo '$'$(echo $base | sed s,+,_,)_SOURCES)
c=$base.c
(cd $srcdest && cat $sources) > $c
o=$base.o
if test ! -e $o -o $c -nt $o; then
    echo "  CC         $c"
    $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o $c
fi
objects=$o
