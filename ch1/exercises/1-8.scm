(define (cube-root x)
  (cube-iter 1.0 x))

(define (cube-iter guess x)
  (if (good-enough? guess x)
      guess
      (cube-iter (improve guess x)
		 x)))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x)) 0.001))

(define (cube x) (* x x x))

(define (improve guess x)
  (average guess (approximate guess x)))

(define (approximate guess x)
  (/ (+ (/ x (square guess))
	(* 2 guess))
     3))

(cube-root 3)
(cube (cube-root 3))
(cube-root 5)
(cube (cube-root 5))
(cube-root 8)
(cube (cube-root 8))

