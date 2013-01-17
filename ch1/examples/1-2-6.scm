;; O(n^(1/2))
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))

(prime? 2)
(prime? 5)
(prime? 4)
(prime? 11)
(prime? 2003)


;; Fermat test O(log(n))
(define (expmod base exp m)
  (cond ((= exp 0) 1)
	((even? exp)
	 (remainder (square (expmod base (/ exp 2) m))
		    m))
	(else
	 (remainder (* base (expmod base (- exp 1) m))
		    m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
	((fermat-test n) (fast-prime? n (- times 1)))
	(else false)))

(fast-prime? 2 5)
(fast-prime? 3 5)
(fast-prime? 5 5)
(fast-prime? 7 5)
(fast-prime? 11 5)
(fast-prime? 13 5)
(fast-prime? 17 5)
(fast-prime? 19 5)
(fast-prime? 15 5)
(fast-prime? 2003 5)
