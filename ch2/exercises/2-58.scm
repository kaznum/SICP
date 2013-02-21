;; Given

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

(define (=number? exp num)
  (and (number? exp) (= exp num)))


(define (deriv exp var)
  (cond ((number? exp) 0)
        ((variable? exp)
         (if (same-variable? exp var) 1 0))
        ((sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var)))
        ((product? exp)
         (make-sum
          (make-product (multiplier exp)
                        (deriv (multiplicand exp) var))
          (make-product (deriv (multiplier exp) var)
                        (multiplicand exp))))
        (else
         (display exp)(error "unknown expression type -- DERIV" exp))))

;;
;; Answer a
;;
(define (sum? x)
  (and (pair? x) (eq? (cadr x) '+)))

(define (addend s) (car s))
(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (cadr x) '*)))

(define (multiplier s) (car s))
(define (multiplicand s) (caddr s))

(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2)) (+ a1 a2))
        (else (list a1 '+ a2))))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))

;; TEST
(deriv '(x + (3 * (x + (y + 2)))) 'x)
(deriv '(x + (3 * ((x * x) + (y + 2)))) 'x)

;;
;; Answer b
;;
;; DIRECTION.
;;
;; At first, separate the expression by '+ and parenthesize
;;   both of elements which are separated.
;;
;; ex:
;;   (1 + 2) + 3 * 4 * 5 + (6 + 7 * 8)
;;   -> (1 + 2) + (3 * 4 * 5 + (6 + 7 * 8))
;;   -> (1 + 2) + ((3 * 4 * 5) + (6 + 7 * 8))
;;   -> (1 + 2) + ((3 * 4 * 5) + (6 + (7 * 8)))
;;
;; Second, Do the same thing by '*
;; ex:
;;   (1 + 2) + ((3 * 4 * 5) + (6 + (7 * 8)))
;;   (1 + 2) + ((3 * (4 * 5)) + (6 + (7 * 8)))
;;
;; The result above is composed only with
;;   the simple '1 operator and 2 components' expressions.
;;

;; no difference from ex2.58 a.
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
	((=number? a2 0) a1)
	((and (number? a1) (number? a2)) (+ a1 a2))
	(else (list a1 '+ a2))))

;; no difference from ex2.58 a.
(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list m1 '* m2))))


(define (refine-parenthesis s)
  (cond ((not (pair? s)) s)
	((null? (cdr s)) (refine-parenthesis (car s)))
	(else s)))

(define (sum? x) (and (pair? x)
		      (not (null? (filter (lambda (e) (eq? e '+)) x)))))

(define (product? x) (and (pair? x)
			  (not (sum? x))
			  (not (null? (filter (lambda (e) (eq? e '*)) x)))))

(define (addend s)
  (define (addend-list s)
    (if (or (null? s) (eq? '+ (car s)))
	'()
	(cons (car s) (addend-list (cdr s)))))
  (refine-parenthesis (addend-list s)))

(define (augend s)
  (define (augend-list s)
    (cond ((null? s) '())
	  ((eq? '+ (car s)) (cdr s))
	  (else (augend-list (cdr s)))))
  (refine-parenthesis (augend-list s)))

(define (multiplier s) (refine-parenthesis (car s)))
(define (multiplicand s)
  (refine-parenthesis (cddr s)))

;; TEST
(sum? '(1 + 2))
(sum? '(1 * 2 + 2))
(sum? '(1 * 2 + (2 + 3)))
(sum? '(1 * 2 * (2 + 3)))
(product? '(1 + 2))
(product? '(1 * 2 + 2))
(product? '(1 * 2 + (2 + 3)))
(product? '(1 * 2 * (2 + 3)))

(addend '(1 + 2))
(addend '(1 * 2 + 2))
(addend '(1 * 2 + (2 + 3)))
(augend '(1 + 2))
(augend '(1 * 2 + 2))
(augend '(1 * 2 + (2 + 3)))

(multiplier '(1 * 2))
(multiplicand '(1 * 2))
(multiplier '((1 + 1) * 2 * 2))
(multiplicand '((1 + 1) * 2 * 2))

(deriv '(x + 3) 'x)
(deriv '(x + x + x) 'x)
(deriv 'x 'x)
(deriv '(2 + x + x + x + 1) 'x)
(deriv '(x * x) 'x)
(deriv '(2 + x * x) 'x)
(deriv '(2 * x + x) 'x)
(deriv '(2 * x * x + x + 1) 'x)
(deriv '(x * x + x + 2 * x) 'x)

(deriv '(x * ((x + x)) + 2 * x) 'x)

;; The sample in the exercise explanation.
(deriv '(x + 3 * (x + y + 2)) 'x)
