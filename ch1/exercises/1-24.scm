(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (next test-divisor)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (next divisor)
  (cond ((= divisor 2) 3)
	(else (+ divisor 2))))

(define (prime? n)
  (= n (smallest-divisor n)))

(define (timed-prime-test n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (fast-prime? n 1000)
      (report-prime n (- (runtime) start-time))))

(define (report-prime n elapsed-time)
  (newline)
  (display n)
  (display " *** ")
  (display elapsed-time))


(define (search-for-primes from to)
  (define (even? n)
    (= 0 (remainder n 2)))
  (if (< from to)
      (if (even? from)
	  (search-for-primes (+ from 1) to)
	  (and (timed-prime-test from) (search-for-primes (+ from 2) to)))))


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



(search-for-primes (expt 10 20) (+ (expt 10 20) 180)) ;; A 0.24
(search-for-primes (expt 10 40) (+ (expt 10 40) 310)) ;; B 0.54
(search-for-primes (expt 10 60) (+ (expt 10 60) 90)) ;; C 0.84
(search-for-primes (expt 10 80) (+ (expt 10 80) 700)) ;; D 1.3

;; D should be double of B but D is a little more than the theory, but almost follows it.
;; A reason for one of this small differences is derived from the condition flow control.

1 ]=> 
100000000000000000039 *** .23999999999999488
100000000000000000129 *** .2400000000000091
100000000000000000151 *** .25
;Unspecified return value

1 ]=> 
10000000000000000000000000000000000000121 *** .5400000000000063
10000000000000000000000000000000000000139 *** .5400000000000063
10000000000000000000000000000000000000301 *** .5499999999999972
;Unspecified return value

1 ]=> 
1000000000000000000000000000000000000000000000000000000000007 *** .8299999999999983
1000000000000000000000000000000000000000000000000000000000067 *** .8399999999999892
1000000000000000000000000000000000000000000000000000000000079 *** .8400000000000034
;Unspecified return value

1 ]=> 
100000000000000000000000000000000000000000000000000000000000000000000000000000129 *** 1.2999999999999972
100000000000000000000000000000000000000000000000000000000000000000000000000000349 *** 1.3299999999999983
100000000000000000000000000000000000000000000000000000000000000000000000000000661 *** 1.3100000000000023
;Unspecified return value
