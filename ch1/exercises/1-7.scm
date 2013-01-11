;; for small number, the predetermined tolerance becomes the large difference relatively.
;; for very large number, the predetermined tolerance is too small because the machine precision (float value presentation) is limited.

;; the following code improves this condition.
;; this code checks the difference between guess and the previous guess
;; FROM http://community.schemewiki.org/?sicp-ex-1.7

(define (sqrt-iter guess oldguess x)
  (if (good-enough? guess oldguess x)
      guess
      (sqrt-iter (improve guess x) guess
		 x)))

(define (good-enough? guess oldguess x)
  (< (abs (- guess oldguess))
     (* guess 0.001)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x)
  (sqrt-iter 1.0 2.0 x))

(sqrt 5)
(sqrt 0.001)
(square (sqrt 10000000000000))
