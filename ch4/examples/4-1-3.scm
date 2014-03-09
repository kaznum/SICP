;;; Testing of predicates

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

;;; Representing procedures
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-paramters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

;;; Operations on Environments


