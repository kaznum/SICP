(define (square x) (* x x))
(define (square x) (exp (double (log x))))
(define (double x) (+ x x))
(square 10)


(define (sqrt x)
  (define (good-enough? guess)
    (< (abs (- (square guess) x)) 0.001))
  (define (improve guess)
    (average guess (/ x guess)))
  (define (sqrt-iter guess)
    (if (good-enough? guess)
	guess
	(sqrt-iter (improve guess))))
  (sqrt-iter 1.0))

(sqrt 9.0)
