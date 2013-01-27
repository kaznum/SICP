;; Procedures as General Methods

;;; Finding roots of equations by the half-interval method
(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
	midpoint
	(let ((test-value (f midpoint)))
	  (cond ((positive? test-value) (search f neg-point midpoint))
		((negative? test-value) (search f midpoint pos-point))
		(else midpoint))))))


(define (close-enough? x y)
  (< (abs (- x y)) 0.001))


(define (half-interval-method f a b)
  (let ((a-value (f a))
	(b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
	   (search f a b))
	  ((and (negative? b-value) (positive? a-value))
	   (search f b a))
	  (else
	   (error "Values are not of opposite sign" a b)))))

(define (average a b)
  (/ (+ a b) 2))
(half-interval-method sin 2.0 4.0)

(half-interval-method (lambda (x) (- (* x x x) (* 2 x) 3))
		      1.0
		      2.0)

;;; Finding fixed points of functions
(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

(fixed-point cos 1.0)

;; y = `sin' y + `cos' y

(fixed-point (lambda (y) (+ (sin y) (cos y))) 1.0)

;; DO NOT TRY. The following becomes infinite loop
(define (sqrt x)
  (fixed-point (lambda (y) (/ x y)) 1.0))

;; The following works
;; Average damping
(define (sqrt x)
  (fixed-point (lambda (y) (average y (/ x y)))
	       1.0))
(sqrt 2)
(sqrt 5)
(sqrt 0.5)
