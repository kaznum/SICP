(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (expmod base (/ exp 2) m))
		    m))
	(else
	 (remainder (* base (expmod base (- exp 1) m))
		    m))))

(define (fermat-test-all n)
  (define (try-it a)
    (if (= a n)
	true
	(if (= (expmod a n n) a)
	    (try-it (+ a 1))
	    false)))
  (try-it 1))

(define (prime? n)
  (fermat-test-all n))

(prime? 15) ; false
(prime? 13) ; true

;; Carmichael numbers (all of the followings are false in fact)
(prime? 561)  ;true
(prime? 1105) ;true
(prime? 1729) ;true
(prime? 2465) ;true
(prime? 2821) ;true
(prime? 6601) ;true






