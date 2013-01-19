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
  (if (prime? n)
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
	  (if (timed-prime-test from)
	      (search-for-primes (+ from 2) to)))))


(search-for-primes 100000000   100000040)
(search-for-primes 1000000000  1000000030)
(search-for-primes 10000000000 10000000065)

;;; original
;; 1 ]=> 
;; 100000007 *** 1.9999999999999574e-2 (0.02s)
;; 100000037 *** 1.9999999999999574e-2
;; 100000039 *** 1.9999999999999574e-2
;; ;Unspecified return value

;; 1 ]=> 
;; 1000000007 *** .05999999999999872 (0.06s)
;; 1000000009 *** .05999999999999872
;; 1000000021 *** .05999999999999872
;; ;Unspecified return value

;; 1 ]=> 
;; 10000000019 *** .19000000000000128 (0.19s)
;; 10000000033 *** .18999999999999773
;; 10000000061 *** .20000000000000284


;;(sqrt 100000000)
;;;; 10000
;;(sqrt 1000000000)
;;;; 31622
;;(sqrt 10000000000)
;;;;100000

;;
;; modified
;;
;; 1 ]=> 
;; 100000007 *** 1.0000000000001563e-2 (0.01s)
;; 100000037 *** 1.0000000000001563e-2
;; 100000039 *** 1.0000000000001563e-2

;; 1 ]=> 
;; 1000000007 *** .0400000000000027    (0.04s)
;; 1000000009 *** .03999999999999915
;; 1000000021 *** .0400000000000027

;; 1 ]=> 
;; 10000000019 *** .120000000000001    (0.12s)
;; 10000000033 *** .129999999999999
;; 10000000061 *** .120000000000001

;; the ratio two-seconds not two.
;; This is because 'next' procedure need some costs
