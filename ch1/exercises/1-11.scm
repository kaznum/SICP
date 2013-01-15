(define (f n) (if (< n 3) n
		  (+ (f (- n 1))
		     (* 2 (f (- n 2)))
		     (* 3 (f (- n 3))))))

(f 0) ;; 0
(f 1) ;; 1
(f 2) ;; 2
(f 3) ;; 4
(f 4) ;; 11
(f 5) ;; 25

(define (f n)
  (define (f-iter a b c n)
    (if (= n 0)
	a
	(f-iter b c (+ c (* 2 b) (* 3 a)) (- n 1))))
  (f-iter 0 1 2 n))
(f 0)
(f 1)
(f 2)
(f 3)
(f 4)
(f 5)
(f 6)

