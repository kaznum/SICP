(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers (integers-starting-from 1))

(define (divisible? x y) (= (remainder x y) 0))
(define no-sevens
  (stream-filter (lambda (x) (not (divisible? x 7)))
		 integers))

(stream-ref no-sevens 100)

(define (fibgen a b) (cons-stream a (fibgen b (+ a b))))
(define fib (fibgen 0 1))

(stream-ref fib 100)

(define (sieve stream)
  (cons-stream
   (stream-car stream)
   (sieve (stream-filter
	   (lambda (x)
	     (not (divisible? x (stream-car stream))))
	   (stream-cdr stream)))))

(define primes (sieve (integers-starting-from 2)))

(stream-ref primes 50)

;;; Defining streams implicitly
(define ones (cons-stream 1 ones))

(define (add-streams s1 s2) (stream-map + s1 s2))

(define integers
  (cons-stream 1 (add-streams ones integers)))

;; (cons 1 (map + (1 1 1...) (cons 1 (map + (1 1 1 ...) (cons 1 (map + (1 1 1)....
;; (cons 1 (cons 2 (map + (1 1 1...) (map + (1 1 1 ...) (cons 1 (map + (1 1 1 ...
;; (cons 1 (cons 2 (cons 3 (map ...

(define fibs
  (cons-stream
   0
   (cons-stream 1 (add-streams (stream-cdr fibs) fibs))))

(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
	      stream))

(define double (cons-stream 1 (scale-stream double 2)))

(stream-car double)
;; 1
(stream-car (stream-cdr double))
;; 2
(stream-car (stream-cdr (stream-cdr double)))
;; 4
(stream-car (stream-cdr (stream-cdr (stream-cdr double))))
;; 8

(define primes
  (cons-stream
   2
   (stream-filter prime? (integers-starting-from 3))))

(define (prime? n)
  (define (iter ps)
    (cond ((> (square (stream-car ps)) n) true)
	  ((divisible? n (stream-car ps)) false)
	  (else (iter (stream-cdr ps)))))
  (iter primes))

(stream-ref primes 5)
(stream-ref primes 10)
