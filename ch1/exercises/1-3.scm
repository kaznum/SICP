(define (square x) (* x x))
(define (sum_of_squares x y)
  (+ (square x) (square y)))

;;(sum_of_squares 2 3)
;; 13

(define (add-larger-two-squares x y z)
  (cond ((< x y)
	 (cond ((< x z) (sum_of_squares y z))
	       (else (sum_of_squares x y))))
	(else (cond ((< y z) (sum_of_squares x z))
		    (else (sum_of_squares x y))))))

;; TEST
(add-larger-two-squares 1 2 3)
(add-larger-two-squares 3 2 1)
(add-larger-two-squares 3 1 2)
(add-larger-two-squares 3 5 2)

;; another answer
;; use 'min'
(define (sum-larger-two-squares x y z)
  (cond ((= (min x y z) x) (sum_of_squares y z))
	((= (min x y z) y) (sum_of_squares x z))
	(else (sum_of_squares x y))))

;; TEST
(sum-larger-two-squares 1 2 3)
(sum-larger-two-squares 3 2 1)
(sum-larger-two-squares 3 1 2)
(sum-larger-two-squares 3 5 2)


;; one more
;; use 'min'
(define (sum-larger-two-squares2 x y z)
  (- (+ (square x) (square y) (square z))
     (square (min x y z))))

;; TEST
(sum-larger-two-squares2 1 2 3)
(sum-larger-two-squares2 3 2 1)
(sum-larger-two-squares2 3 1 2)
(sum-larger-two-squares2 3 5 2)
