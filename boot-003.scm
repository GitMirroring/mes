;; Mes

(define display  core:display)
(define write core:write)
(define mes %version)
(define (primitive-eval e) (core:eval e (current-environment)))
(define else #t)

(define-macro (and . x)
  (if (null? x) #t
      (if (null? (cdr x)) (car x)
          (list (quote if) (car x) (cons (quote and) (cdr x))
                #f))))

(define (hashq-ref table key . rest)
  (core:hashq-ref table key (and (pair? rest) (car rest))))

;; (define (defined? x)
;;   ((lambda (v) (if v (if (eq? (variable-ref v) *undefined*) #f #t) #f))
;;    (hashq-ref (initial-module) x #f)))

(define (defined? x)
  ((lambda (v)
     (if v (if (eq? (variable-ref v) *undefined*) #f #t) #f))
   (core:hashq-ref (initial-module) x #f)))


;; (define (defined? x)
;;   #t)

;; (define (defined? x)
;;   (display "defined? 00\n")
;;   (display "x=") (write x) (display "\n")
;;   (display "initial-module=") (write (initial-module)) (display "\n")
;;   (display "REF=") (hashq-ref (initial-module) x #f) (display "\n")
;;   ((lambda (v)
;;      (display "v=") (write v) (display "\n")
;;      (if v (if (eq? (variable-ref v) *undefined*) #f #t) #f))

;;    (hashq-ref (initial-module) x #f)))

;; (define (defined? x)
;;   (module-defined? (current-module) x))

;; (define (pk . stuff)
;;   (display "\n")
;;   (display "\n")
;;   (display ";;; ")
;;   (write stuff)
;;   (display "\n")
;;   (car (last-pair stuff)))

(define (cond-expand-expander clauses)
  ;; (display "CEE 00\n")
  ;; (display "clauses:") (write clauses) (display "\n")
  (if (null? clauses) (display "NO MATCH!\n")
      (begin
        ;; (display "FIRST:")
        ;; (write (car clauses))
        ;; (display "\n")

        ;; (display "TEST:")
        ;; (write (car (car clauses)))
        ;; (display "\n")
        (if (defined? (car (car clauses)))
            (begin
              ;; (display "clause=>")
              ;; (display (car (car clauses)))
              ;; (display "\n")
              (cdr (car clauses)))
            (begin
              ;; (display "recursing...")
              (cond-expand-expander (cdr clauses)))))))

(define-macro (cond-expand . clauses)
  (cons 'begin (cond-expand-expander clauses)))
;; end boot-00.scm

;;(primitive-load 0)

1

(core:display "100\n")
(cond-expand
 (guile
  (display "YAY, Guile!\n"))
 (mes
  (display "YAY, Mes!\n"))
 (else
  (display "BOO!\n")))

(core:display "200\n")

(exit 22)
