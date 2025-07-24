;;; GNU Mes --- Maxwell Equations of Software
;;; Copyright © 2025 Matt Wette <matt.wette@gmail.com>
;;; Copyright © 2025 Janneke Nieuwenhuizen <janneke@gnu.org>
;;;
;;; This file is part of GNU Mes.
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

;;; Commentary:

;;; Minimalist match implementation, [just] enough to support running NYACC.

;;; Code:

(define-syntax match
  (syntax-rules ()
    ((_ e . c)
     (let ((v e)) (match-1 v . c)))))

(define-syntax match-1
  (syntax-rules (quote quasiquote unquote)
    ((_ v) (if #f #f))
    ((_ v (pat e0 . e) . c)
     (let ((k (lambda () (match-1 v . c))))
       (match-pat v pat (let () e0 . e) (k))))))

(define-syntax match-pat
  (syntax-rules (quote quasiquote)
    ((_ v '() kt kf) (if (null? v) kt kf))
    ((_ v (quote w) kt kf) (if (equal? v (quote w)) kt kf))
    ((_ v (quasiquote w) kt kf) (match-qqpat v w kt kf))
    ((_ v (unquote w) kt kf) (let ((w v)) kt))
    ((_ v (x . y) kt kf) (if (pair? v)
                             (match-pat (car v) x
                                        (match-pat (cdr v) y kt kf) kf)
                             kf))
    ((_ v lit kt kf) (if (eq? v (quote lit)) kt kf))))

(define-syntax match-qqpat
  (syntax-rules (unquote)
    ((_ v '() kt kf) (if (null? v) kt kf))
    ((_ v (unquote s) kt kf) (let ((s v)) kt))
    ((_ v (x . y) kt kf) (if (pair? v)
                             (match-qqpat (car v) x
                                          (match-qqpat (cdr v) y kt kf) kf)
                             kf))
    ((_ v w kt kf) (if (eq? v (quote w)) kt kf))))
