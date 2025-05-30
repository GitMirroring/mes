;;; GNU Mes --- Maxwell Equations of Software
;;; Copyright © 2016,2017,2018,2022 Janneke Nieuwenhuizen <janneke@gnu.org>
;;; Copyright © 2023 Ekaitz Zarraga <ekaitz@elenq.tech>
;;; Copyright © 2024,2025,2026 Timothy Sample <samplet@ngyro.com>
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

;; Boot just enough type checking to run the loader and expander
(define (symbol? x)
  (eq? (core:type x) <cell:symbol>))

(define (number? x)
  (eq? (core:type x) <cell:number>))

(define (string? x)
  (eq? (core:type x) <cell:string>))

(define (port? x)
  (eq? (core:type x) <cell:port>))

(define (closure? x)
  (eq? (core:type x) <cell:closure>))

;; The expander
(define %macro-table (make-hash-table))

(define (define-macro! name proc)
  (if (closure? proc)
      (hashq-set! %macro-table name proc)
      (error "define-macro!: not a closure" proc)))

(define (expand form)
  (if (pair? form)
      (if (symbol? (car form))
          (expand-keyword-pair (car form) (cdr form))
          (cons (expand (car form))
                (expand-cdr (cdr form))))
      form))

(define (expand-keyword-pair keyword rest)
  (define xformer (core:hashq-ref %macro-table keyword #f))
  (if xformer
      (core:apply xformer rest)
      (cons keyword (expand-cdr rest))))

(define (expand-cdr form)
  (if (pair? form)
      (if (eq? (car form) *undefined*)
          (cons *undefined*
                (expand-cdr (cdr form)))
          (cons (expand (car form))
                (expand-cdr (cdr form))))
      (expand form)))

(define core:macro-expand expand)

;; The binder
(define (name->binding name)
  (define var (current-module-variable name #f))
  (if var
      (make-binding name var)
      (make-binding name (current-module-variable name #t))))

(define (formals->alist formals)
  (if (null? formals)
      '()
      (if (symbol? formals)
          (list (cons formals #t))
          (cons (cons (car formals) #t)
                (formals->alist (cdr formals))))))

(define (add-formals formals env)
  (cons (formals->alist formals) env))

(define (lexical? name env)
  (if (null? env)
      #f
      (if (assq name (car env))
          #t
          (lexical? name (cdr env)))))

(define (bind! form env)
  (if (pair? form)
      (if (eq? (car form) 'quote)
          form
          (if (eq? (car form) 'lambda)
              (bind-lambda! form env)
              (if (eq? (car form) 'define)
                  (bind-define! form env)
                  (begin
                    (set-car! form (bind! (car form) env))
                    (set-cdr! form (bind-cdr! (cdr form) env))
                    form))))
      (if (symbol? form)
          (if (lexical? form env)
              form
              (name->binding form))
          form)))

(define (bind-lambda! form env)
  (define formals (car (cdr form)))
  (define body (cdr (cdr form)))
  (set-cdr! (cdr form) (bind-body! body (add-formals formals env)))
  form)

(define (gather-defines forms defines)
  (if (pair? forms)
      (if (pair? (car forms))
          (if (eq? (car (car forms)) 'define)
              (gather-defines
               (cdr forms)
               (cons (if (pair? (car (cdr (car forms))))
                         (car (car (cdr (car forms))))
                         (car (cdr (car forms))))
                     defines))
              defines)
          defines)
      defines))

(define (bind-body! body env)
  (bind-cdr! body (add-formals (gather-defines body '()) env)))

(define (bind-define! form env)
  (if (pair? (car (cdr form)))
      (begin
        (set-cdr! (cdr form)
                  (bind-body! (cdr (cdr form))
                              (add-formals (cdr (car (cdr form))) env)))
        form)
      (begin
        (set-cdr! (cdr form) (bind-cdr! (cdr (cdr form)) env))
        form)))

(define (bind-cdr! rest env)
  (if (pair? rest)
      (if (eq? (car rest) *undefined*)
          (begin
            (set-cdr! rest (bind-cdr! (cdr rest) env))
            rest)
          (begin
            (set-car! rest (bind! (car rest) env))
            (set-cdr! rest (bind-cdr! (cdr rest) env))
            rest))
      (bind! rest env)))

;; Use the expander and binder for 'eval'
(define (eval form)
  (core:eval-expanded (bind! (expand form) '()) '((#f . #f))))

;; Emulate the old 'core:eval'.
(define (core:eval form env)
  (core:eval-expanded (bind! (expand form) (list env)) env))

;; System macros
(define (quote-expander form)
  (list 'quote form))

(define (lambda-expander formals . body)
  (cons 'lambda (cons formals (expand-cdr body))))

(define (if-expander test consequent . rest)
  (define alternate (if (pair? rest) (car rest) *unspecified*))
  (list 'if (expand test) (expand consequent) (expand alternate)))

(define (begin-expander . forms)
  (cons 'begin (expand-cdr forms)))

(define (set!-expander name exp)
  (list 'set! name (expand exp)))

(define (define-expander name+formals . body)
  (if (pair? name+formals)
      (cons 'define (cons name+formals (expand-cdr body)))
      (list 'define name+formals (expand (car body)))))

(define-macro! 'quote quote-expander)
(define-macro! 'lambda lambda-expander)
(define-macro! 'if if-expander)
(define-macro! 'begin begin-expander)
(define-macro! 'set! set!-expander)
(define-macro! 'define define-expander)

;; User macros
(define (wrap-user-macro proc)
  (lambda rest (expand (core:apply proc rest))))

(define (eval-and-define-macro! name form)
  (define-macro! name (wrap-user-macro (eval form)))
  *unspecified*)

(define (define-macro-expander name+formals . body)
  (if (pair? name+formals)
      (eval-and-define-macro! (car name+formals)
                              (cons 'lambda
                                    (cons (cdr name+formals) body)))
      (eval-and-define-macro! name+formals (car body))))

(define-macro! 'define-macro define-macro-expander)

;; The loader
(define (%read-and-eval on-last! form next-form)
  (if (null? next-form)
      (begin
        (on-last!)
        (eval form))
      (begin
        (eval form)
        (%read-and-eval on-last! next-form (read-env '())))))

(define (read-and-eval on-last! form)
  (if (null? form)
      (begin
        (on-last!)
        *unspecified*)
      (%read-and-eval on-last! form (read-env '()))))

(define (load-from-current-input)
  (read-and-eval (lambda () *unspecified*) (read-env '())))

(define (load-from-port port)
  (define prev (set-current-input-port port))
  (read-and-eval (lambda ()
                   (set-current-input-port prev))
                 (read-env '())))

(define (check-close-port)
  ((lambda (v)
     (if v (if (eq? (variable-ref v) *undefined*) #f #t) #f))
   (core:hashq-ref (initial-module) 'close-port #f)))

(define has-close-port? (check-close-port))

(define (load-from-file filename)
  (define port (open-input-file filename))
  (define prev (set-current-input-port port))
  (read-and-eval (lambda ()
                   (set-current-input-port prev)
                   (if has-close-port?
                       (close-port port)
                       #t))
                 (read-env '())))

(define (primitive-load filename)
  (if (if (number? filename)
          (= filename 0)
          #f)
      (load-from-current-input)
      (if (port? filename)
          (load-from-port filename)
          (if (string? filename)
              (load-from-file filename)
              (error "primitive-load failed" filename)))))

;; Boot dispatch
(define (boot-file basename)
  (string-append %datadir "/module/mes/" basename))

(define boot-table
  (list (cons "boot-5.scm" (boot-file "boot-5.scm"))
        (cons "boot-0.scm" (boot-file "boot-0.scm"))
        (cons "boot-00.scm" (boot-file "boot-00.scm"))
        (cons "boot-01.scm" (boot-file "boot-01.scm"))
        (cons "boot-02.scm" (boot-file "boot-02.scm"))
        (cons "boot-03.scm" (boot-file "boot-03.scm"))
        (cons "boot.scm" 0)))

(define initial-mes-boot (getenv "MES_BOOT"))
(define mes-boot (if initial-mes-boot initial-mes-boot "boot-5.scm"))
(define mes-boot-handle (assoc mes-boot boot-table))
(define mes-boot-file
  (if mes-boot-handle
      (cdr mes-boot-handle)
      (error "boot: invalid MES_BOOT" mes-boot)))

(primitive-load mes-boot-file)
