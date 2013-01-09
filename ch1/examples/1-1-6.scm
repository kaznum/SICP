
;; case analysis with 'cond'
(define (abs x)
  (cond ((> x 0) x)
	((= x 0) 0)
	((< x 0) (- x))))
(abs 5)
(abs -1)
(abs 0)

;; how to use 'else'
(define (abs2 x)
  (cond ((< x 0) (- x))
	(else x)))
(abs2 5)
(abs2 -1)
(abs2 0)

;; with 'if'
(define (abs3 x)
  (if (< x 0)
      (- x)
      x))

(abs3 5)
(abs3 -1)
(abs3 0)

;; and
(and (> 5 3)
     (= 1 1)
     (< 2 3))
(and 3 2 1)
(and 3 #f 1)

;; or
(or (> 1 3)
     (= 1 1)
     (< 5 3))

(or (> 1 3)
     (= 0 1)
     (< 5 3))

(or #f #f 5)
(or #f #f (< 5 3))

;;(and (> x 5) (< x 10))

(define (>= x y)
  (or (> x y) (= x y)))

(>= 2 3)
(>= 5 3)
(>= 3 3)

(define (>= x y)
  (not (< x y)))

(>= 2 3)
(>= 5 3)
(>= 3 3)
