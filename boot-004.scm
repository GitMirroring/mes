;; make -f simple.make && MES_DEBUG=5 MES_BOOT=boot-000.scm ./pre-inst-env mes-gcc

(define (primitive-eval e) (core:eval e (current-environment)))

(define-macro (when expr . body)
  (list 'if expr
        (list (append2 (list 'lambda ()) body))))

(define (test)
  (when #t
    (core:display "test\n")))

(test)
(test)
(test)
(exit 22)
