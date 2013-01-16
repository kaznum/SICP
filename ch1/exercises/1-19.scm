p = 0
q = 1

a = 1
b = 0

;; ;; 1回目の適用
;; T_(pq) = T(0)
;; -> a' = bq + aq + ap = 0 + 1 + 0 = 1
;; -> b' = bp + aq = 0 + 1 = 1
;;
;; ;; 2回目の適用
;; a'' = b'q + a'q + a'p =  1 + 1 + 0 = 2
;; b'' = b'p + a'q = 0 + 1 = 1
;;
;; a'' = (bp + aq)q + (bq + aq + ap)q +  (bq + aq + ap)p
;;     = bpq + aq^2 + bq^2 + aq^2 + apq + bpq + apq + ap^2
;;     = 2bpq + 2aq^2 + bq^2 + 2apq + ap^2
;;     = b(2pq + q^2) + a(2q^2 + 2pq + p^2)
;;     = b(2pq + q^2) + a(2pq + q^2) + a(q^2 + p^2)
;;     = bq' + aq' + ap'
;; ;; よって
;; p' = p^2 + q^2
;; q' = 2pq + q^2


(define (fib n)
  (fib-iter 1 0 0 1 n))

(define (fib-iter a b p q count)
  (cond ((= count 0) b)
	((even? count)
	 (fib-iter a
		   b
		   (+ (* p p) (* q q))
		   (+ (* 2 p q) (* q q))
		   (/ count 2)))
	(else (fib-iter (+ (* b q) (* a q) (* a p))
			(+ (* b p) (* a q))
			p
			q
			(- count 1)))))


(fib 2)
(fib 3)
(fib 4)
(fib 5)
(fib 6)
(fib 7)
(fib 8)
(fib 9)
