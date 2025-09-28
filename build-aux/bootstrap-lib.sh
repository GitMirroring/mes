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

objects=
for c in $libc_mini_SOURCES; do
    b=$(echo $c | sed -re s,^[.]+/,, -e s,/,-,g -e s,[.]c$,,)
    o=$b.o
    if test ! -e $o -o ${srcdest}$c -nt $o; then
        echo "  CC         $c"
        $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o ${srcdest}$c
    fi
    objects="$objects $o"
done
echo "  AR         $mes_cpu-mes/libc-mini.a"
$AR crD $mes_cpu-mes/libc-mini.a $objects

objects=
for c in $libmescc_SOURCES; do
    b=$(echo $c | sed -re s,^[.]+/,, -e s,/,-,g -e s,[.]c$,,)
    o=$b.o
    if test ! -e $o -o ${srcdest}$c -nt $o; then
        echo "  CC         $c"
        $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o ${srcdest}$c
    fi
    objects="$objects $o"
done
echo "  AR         $mes_cpu-mes/libmescc.a"
$AR crD $mes_cpu-mes/libmescc.a $objects

objects=
for c in $libc_SOURCES; do
    b=$(echo $c | sed -re s,^[.]+/,, -e s,/,-,g -e s,[.]c$,,)
    o=$b.o
    if test ! -e $o -o ${srcdest}$c -nt $o; then
        echo "  CC         $c"
        $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o ${srcdest}$c
    fi
    objects="$objects $o"
done
echo "  AR         $mes_cpu-mes/libc.a"
$AR crD $mes_cpu-mes/libc.a $objects

objects=
for c in $libc_tcc_SOURCES; do
    b=$(echo $c | sed -re s,^[.]+/,, -e s,/,-,g -e s,[.]c$,,)
    o=$b.o
    if test ! -e $o -o ${srcdest}$c -nt $o; then
        echo "  CC         $c"
        $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o ${srcdest}$c
    fi
    objects="$objects $o"
done
echo "  AR         $mes_cpu-mes/libc+tcc.a"
$AR crD $mes_cpu-mes/libc+tcc.a $objects

AM_CPPFLAGS="$AM_CPPFLAGS -I ${srcdest}src"

objects=
for c in $mes_SOURCES; do
    b=$(echo $c | sed -re s,^[.]+/,, -e s,/,-,g -e s,[.]c$,,)
    o=$b.o
    if test ! -e $o -o ${srcdest}$c -nt $o; then
        echo "  CC         $c"
        $CC -c $AM_CPPFLAGS $CPPFLAGS $AM_CFLAGS $CFLAGS -o $o ${srcdest}$c
    fi
    objects="$objects $o"
done
