;; sqrt by Newton's method
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


;; 5-3-1.jpg: when good-enough? and improve are primitives
;; 5-3-2.jpg: when they are replaced with arithmetic operations (WIP)
