(define (square x) (* x x))
(square 1.2)
(square 21)
(square (+ 2 5))
(square (square 3))

(define (sum-of-squares x y) (+ (square x) (square y)))
(sum-of-squares 3 4)

;; use symbol as a building block in constructing further procedure
(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))

(f 5)


