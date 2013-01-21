(define (expmod-millar-rabin base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (trivial-modulo (expmod-millar-rabin base (/ exp 2) m) m)) m))
	(else (remainder (* base (expmod-millar-rabin base (- exp 1) m)) m))))


(define (trivial-modulo r m)
  (if (and (not (= r 1))
	   (not (= r (- m 1)))
	   (= 1 (remainder (square r) m)))
      0
      r))
	   
(define (millar-rabin-test n)
  (define (try-it a)
    (= (expmod-millar-rabin a (- n 1) n) 1))
  (try-it (+ 1 (random (- n 1)))))

(define (millar-rabin-prime? n)
  (millar-rabin-test n))

(millar-rabin-prime? 2)
(millar-rabin-prime? 4)
(millar-rabin-prime? 11)
(millar-rabin-prime? 23)
(millar-rabin-prime? 25)

(millar-rabin-prime? 561)
(millar-rabin-prime? 1105)
(millar-rabin-prime? 1729)
(millar-rabin-prime? 2465)
(millar-rabin-prime? 2821)
(millar-rabin-prime? 6601)

