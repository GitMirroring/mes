;;; GNU Mes --- Maxwell Equations of Software
;;; Copyright © 2022 Jan (janneke) Nieuwenhuizen <janneke@gnu.org>
;;;
;;; This file is part of GNU Mes.
;;;
;;; Also borrowing code from:
;;; guile-sdl2 --- FFI bindings for SDL2
;;; Copyright © 2015 David Thompson <davet@gnu.org>
;;;
;;; GNU Mes is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Mes is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Mes.  If not, see <http://www.gnu.org/licenses/>.

(define-module (git fixes)
  #:use-module (gnu packages)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages libsigsegv))

(define original-libsigsegv (@ (gnu packages libsigsegv) libsigsegv))

(define-public original-libsigsegv;-no-tests
  (package
    (inherit original-libsigsegv)
    (arguments
     `(#:tests? #f
       ,@(package-arguments original-libsigsegv)))))
