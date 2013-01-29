(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeated f n)
  (if (< n 1)
      identity
      (compose f (repeated f (- n 1)))))

(define dx 0.01)

(define (smooth f)
  (lambda (x)
    (/ (+ (f (- x dx))
	  (f x)
	  (f (+ x dx)))
       3.0)))

(define (n-smooth f n)
  ((repeated smooth n) f))

;; TEST
((smooth (lambda (x) (* 3 x x))) 2)
((n-smooth (lambda (x) (* 3 x x)) 3) 2)

