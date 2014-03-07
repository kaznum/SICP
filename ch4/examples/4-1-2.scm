(define (self-evaluating? exp)
  (cond ((number? exp) true)
	((string? exp) true)
	(else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (caddr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)   ;; formal parameters
		   (cddr exp)))) ;; body

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-paramters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda paramters body)
  (cons' lambda (cons paramters body)))
