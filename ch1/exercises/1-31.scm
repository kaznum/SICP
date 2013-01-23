;; a (recursive)
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
	 (product term (next a) next b))))

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
(define (product-i term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a) (* result (term a)))))
  (iter a 1))

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

