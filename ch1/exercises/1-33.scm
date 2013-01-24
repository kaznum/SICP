(define (filtered-accumulate combiner null-value term a next b filter)
  (if (> a b)
      null-value
      (if (filter a)
	  (combiner (term a) (filtered-accumulate combiner null-value term (next a) next b filter))
	  (filtered-accumulate combiner null-value term (next a) next b filter))))



;;TEST
(define (sum term a next b)
  (define (filter x) true)
  (filtered-accumulate + 0 term a next b filter))
(define (sum-cubes a b)
  (define (inc n) (+ n 1))
  (sum cube a inc b))
(sum-cubes 1 10)

;; a
(define (smallest-div n)
  (define (divides? a b)
    (= 0 (remainder b a)))
  (define (find-div n test)
    (cond ((> (square test) n) n)
	  ((divides? test n) test)
	  (else (find-div n (+ test 1)))))
  (find-div n 2))

(define (prime? n)
  (if (= n 1)
      false
      (= n (smallest-div n))))

(define (square_prime a b)
  (define (filter a) (prime? a))
  (define (term x) (* x x))
  (define (next x) (+ 1 x))
  (filtered-accumulate + 0 term a next b filter))

(square_prime 2 3)
(square_prime 4 15)

(define (gcd x y)
  (define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

(define (product-relative-primes n)
  (define (filter a) (= (gcd n a) 1))
  (define (next x) (+ 1 x))
  (filtered-accumulate * 1 identity 1 next n filter))

(product-relative-primes 10)

