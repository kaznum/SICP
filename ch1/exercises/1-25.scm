(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (expmod base (/ exp 2) m))
		    m))
	(else
	 (remainder (* base (expmod base (- exp 1) m))
		    m))))

(define (expmod2 base exp m)
  (define (fast-expt base exp)
    (cond  ((= exp 0) 1)
	   ((even? exp) (square (fast-expt base (/ exp 2))))
	   (else (* base (fast-expt base (- exp 1))))))
  (remainder (fast-expt base exp) m))


(expmod  5929921999 99898 12)
(expmod2 5929921999 99898 12)

;; expmod2 constructs very large numbers in iterative process of fast-expt but original only treat a number less than m^2 which is so much cost-effective.
