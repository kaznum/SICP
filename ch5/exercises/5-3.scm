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

(controller
 (assign g (const 1.0))
 test-good-enough?
 (test (op good-enough?) (reg g) (reg x))
 (branch (label end))
 (assign g (op improve) (reg g) (reg x))
 (goto (label test-good-enough?))
 end)
;; 5-3-2.jpg: when they are replaced with arithmetic operations

(controller
 (assign g (const 1.0))
 test-good-enough?
 (assign t1 (op square) (reg g))
 (assign t2 (op -) (reg t1) (reg x))
 (assign t3 (op abs) (reg t2))
 (test (op <) (reg t3) (const 0.001))
 (branch (label end))
 (assign t4 (op /) (reg x) (reg g))
 (assign g (average (reg t4) (reg g)))
 (goto (label test-good-enough?))
 end)

