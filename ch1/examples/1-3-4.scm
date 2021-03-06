(define (average x y)
  (/ (+ x y) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

((average-damp square) 10)


;; definition of fixed-point
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

;; redefine sqrt whithc fixed-point and average-damp
(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
	       1.0))

(sqrt 3)
(sqrt 5)

;; redefine cube-root
;; y^3 = x
;; y = x / y^2

(define (cube-root x)
  (fixed-point (average-damp (lambda (y) (/ x (* y y))))
	       1.0))

(cube-root 27)
(cube-root 8)
(cube-root 10)
(cube-root 1)


;; Newton's method

(define (deriv g)
  (lambda (x)
    (/ (- (g (+ x dx)) (g x))
       dx)))

(define dx 0.00001)

;;; deriv test
(define (cube x) (* x x x))

((deriv cube) 5)
;; 75.00014999664018


(define (newton-transform g)
  (lambda (x)
    (- x (/ (g x) ((deriv g) x)))))

(define (newtons-method g guess)
  (fixed-point (newton-transform g) guess))

(define (sqrt x)
  (newtons-method (lambda (y) (- (square y) x))
		  1.0))

(sqrt 1)
(sqrt 2)
(sqrt 3)
(sqrt 4)
(sqrt 5)

;; Abstractions and first-class procedures
(define (fixed-point-of-transform g transform guess)
  (fixed-point (transform g) guess))

;; average-damp sqrt
(define (sqrt x)
  (fixed-point-of-transform (lambda (y) (/ x y))
			    average-damp
			    1.0))

(sqrt 5)

;; Newton's method
(define (sqrt x)
  (fixed-point-of-transform (lambda (y) (- (square y) x))
			    newton-transform
			    1.0))
(sqrt 5)


