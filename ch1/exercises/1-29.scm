(define (h a b n)
  (/ (- b a) n))

(define (term f a b n k)
  (cond ((= k 0) (f a))
	((= k n) (f b))
	((even? k) (* 2 (f (+ a (* k (h a b n))))))
	(else  (* 4 (f (+ a (* k (h a b n))))))))

(define (next k)
  (+ k 1))

(define (sum f a b n k)
  (if (> k n)
      0
      (+ (term f a b n k)
	 (sum f a b n (next k)))))

(define (simpson-rule f a b n)
  (* (/ (h a b n) 3) (sum f a b n 0)))

(define (cube n)
  (* n n n))

(simpson-rule cube 0 1.0 100)
;Value: .24999999999999992

(simpson-rule cube 0 1.0 1000)
;Value: .2500000000000003

(integral cube 0 1 0.01)
;;.24998750000000042
(integral cube 0 1 0.001)
;;.249999875000001
