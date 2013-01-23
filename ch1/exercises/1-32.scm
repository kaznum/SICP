;; a (recursive)

(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate combiner null-value term (next a) next b))))

(define (sum term a next b)
  (accumulate + 0 term a next b))

(define (sum-cubes a b)
  (define (inc n) (+ n 1))
  (sum cube a inc b))

(sum-cubes 1 10)


(define (product term a next b)
  (accumulate * 1 term a next b))

(define (factorial n)
  (define (inc k)
    (+ k 1))
  (product identity 1 inc n))
(factorial 3)
(factorial 4)
(factorial 5)

(define (quart-pi n)
  (define (inc k)
    (+ 2 k))
  (define (term n)
    (/ (* n (+ n 2)) (* (+ n 1) (+ n 1))))
  (product term 2 inc n))

(* 4.0 (quart-pi 10000))    ;; 3.1417497057380523
(* 4.0 (quart-pi 100000))   ;; Aborting!: maximum recursion depth exceeded


;; b iterative procedure
(define (accumulate-i combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a) (combiner result (term a)))))
  (iter a null-value))

(define (sum-i term a next b)
  (accumulate-i + 0 term a next b))
(define (sum-cubes-i a b)
  (define (inc n) (+ n 1))
  (sum-i cube a inc b))

(sum-cubes-i 1 10)

(define (product-i term a next b)
  (accumulate-i * 1 term a next b))

(define (factorial-i n)
  (define (inc k)
    (+ k 1))
  (product-i identity 1 inc n))
(factorial-i 3)
(factorial-i 4)
(factorial-i 5)

(define (quart-pi-i n)
  (define (inc k)
    (+ 2 k))
  (define (term n)
    (/ (* n (+ n 2)) (* (+ n 1) (+ n 1))))
  (product-i term 2 inc n))

(* 4.0 (quart-pi-i 10000))    ;; 3.1417497057380523
(* 4.0 (quart-pi-i 100000))   ;; 3.1416083612781764

