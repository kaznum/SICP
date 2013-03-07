;; Given in previous chapters
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;; Given in this exercise
(define (deriv exp var)
  (cond ((number? exp) 0)
	((variable? exp) (if (same-variable? exp var) 1 0))
	(else ((get 'deriv (operator exp)) (operands exp)
	       var))))

(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

;; a)
;; In deriv, the `else' clause have (operator exp).
;; This means that `'deriv' needs to have operator and only number or variable in 
;; exp is impossible to apply `operator'


;; b)
(define (=number? exp num)
  (and (number? exp) (= exp num)))

(define (install-sum-package)
  (define (make-sum a1 a2)
    (cond ((=number? a1 0) a2)
	  ((=number? a2 0) a1)
	  ((and (number? a1) (number? a2)) (+ a1 a2))
	  (else (list '+ a1 a2))))
  (define (addend exp) (car exp))
  (define (augend exp) (cadr exp))
  (define (private-deriv operands var)
    (make-sum (deriv (addend operands) var)
	      (deriv (augend operands) var)))
  (put 'make-sum '+ make-sum)
  (put 'deriv '+ private-deriv)
  'done)


(define (install-product-package)
  ;; make make-sum public to use in install-product-package
  (define (make-sum a1 a2)
    ((get 'make-sum '+) a1 a2))
  (define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0)) 0)
	  ((=number? m1 1) m2)
	  ((=number? m2 1) m1)
	  ((and (number? m1) (number? m2)) (* m1 m2))
	  (else (list '* m1 m2))))
  (define (multiplier s) (car s))
  (define (multiplicand s) (cadr s))
  (define (private-deriv operands var)
    (make-sum
     (make-product (multiplier operands)
		   (deriv (multiplicand operands) var))
     (make-product (deriv (multiplier operands) var)
		   (multiplicand operands))))
  (put 'make-product '* make-product)
  (put 'deriv '* private-deriv)
  'done)

;; TEST
(define get 2d-get)
(define put 2d-put!)

(install-sum-package)
(install-product-package)

(deriv '0 'x)
(deriv 'x 'x)

(deriv '(+ 2 x) 'x)
(deriv '(* 2 x) 'x)
(deriv '(+ (* 2 x) (* 3 (* x x))) 'x)
(deriv '(+ (* 2 x) (* x (* 3 y))) 'y)

;; c)

(define (install-exponentiation-package)
  ;; make make-sum public to use in install-product-package
  (define (make-sum a1 a2)
    ((get 'make-sum '+) a1 a2))
  (define (make-product a1 a2)
    ((get 'make-product '*) a1 a2))
  (define (base e) (car e))
  (define (exponent e) (cadr e))
  (define (make-exponentiation b e)
    (cond ((=number? e 0) 1)
	  ((=number? e 1) b)
	  (else (list '** b e))))
  (define (private-deriv exp var)
    (make-product (make-product (exponent exp)
				(make-exponentiation (base exp) (make-sum (exponent exp) (- 1))))
		  (deriv (base exp) var)))
  (put 'make-exponentiation '** make-exponentiation)
  (put 'deriv '** private-deriv)
  'done)

(install-exponentiation-package)
(deriv '(** x 2) 'x)
(deriv '(* 2 (** (+ x 1) 3)) 'x)

;; d)
;; All the code to be changed is the order of arguments of `put' and `get'
;;  (put '* 'deriv deriv)


