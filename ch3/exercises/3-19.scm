;; Do not create a pair list
;; Check whether the current pair occurs in the pairs following it.

(define (occur-again? me exp)
  (cond ((not (pair? me)) false)
	((not (pair? exp)) false)
	((null? me) false)
	((null? exp) false)
	((eq? me (car exp)) true)
	((eq? me (cdr exp)) true)
	(else
	 (or (occur-again? me (car exp))
	     (occur-again? me (cdr exp))
	     (occur-again? (car me) (car exp))
	     (occur-again? (cdr me) (car exp))
	     (occur-again? (car me) (cdr exp))
	     (occur-again? (cdr me) (cdr exp))))))

(define (loop-exists? exp)
  (or (occur-again? exp (car exp)) (occur-again? exp (cdr exp))))


(loop-exists? '(a b c d))
;Value: #f

;;; loop in cdr
(define p1 '(x y z))
(loop-exists? (list 'a p1 p1))
;Value: #f
(set-cdr! (cddr p1) p1)
(loop-exists? p1)
;Value: #t

;;; loop in car
(define p2 '(x y z))
(loop-exists? p2)
;Value: #f
(set-car! (cdr p2) p2)
(loop-exists? p2)
;Value: #t
