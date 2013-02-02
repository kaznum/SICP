;; preparation
(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
		 (+ (upper-bound x) (upper-bound y))))

(define (sub-interval x y)
  (make-interval (- (lower-bound x) (upper-bound y))
		 (- (upper-bound x) (lower-bound y))))

(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
	(p2 (* (lower-bound x) (upper-bound y)))
	(p3 (* (upper-bound x) (lower-bound y)))
	(p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
		   (max p1 p2 p3 p4))))


(define (div-interval x y)
  (mul-interval x (make-interval (/ 1.0 (upper-bound y))
				 (/ 1.0 (lower-bound y)))))

(define (make-interval a b) (cons a b))

(define (upper-bound x) (max (car x) (cdr x)))
(define (lower-bound x) (min (car x) (cdr x)))

(define (width x) (/ (- (upper-bound x) (lower-bound x)) 2))

;; width of (sum of two intervals)
(width (add-interval x y))

(width (make-interval (+ (lower-bound x) (lower-bound y))
		      (+ (upper-bound x) (upper-bound y))))

(/ (- (+ (upper-bound x) (upper-bound y))
      (+ (lower-bound x) (lower-bound y)))
   2)

(/ (+ (- (upper-bound x) (lower-bound x))
      (- (upper-bound y) (lower-bound y)))
   2)

(+ (/ (- (upper-bound x) (lower-bound x)) 2)
   (/ (- (upper-bound y) (lower-bound y)) 2))

;; the answer of the width of sum
(+ (width x) (width y))


(width (sub-interval x y))

(width
 (make-interval (- (lower-bound x) (upper-bound y))
		(- (upper-bound x) (lower-bound y))))

(/ (- (- (upper-bound x) (lower-bound y))
      (- (lower-bound x) (upper-bound y)))
   2)

(/ (+ (- (upper-bound x) (lower-bound x))
      (- (upper-bound y) (lower-bound y)))
   2)

;; the answer of the width of sub
(+ (width x) (width y))


;; mul
(mul-interval (make-interval 1 2) (make-interval 3 5))

(let ((p1 (* 1 3))
      (p2 (* 1 5))
      (p3 (* 2 3))
      (p4 (* 2 5)))
  (make-interval (min p1 p2 p3 p4)
		 (max p1 p2 p3 p4)))

(make-interval (min 3 5 6 10)
	       (max 3 5 6 10))
(make-interval 3 10)

;; width is (10 - 3)/2 = 3.5

;; (add-interval (make-interval 1 2) (make-interval 3 5))'s width is (2 - 1)/2 + (5 - 3)/2 = 0.5 + 1 = 1.5 <> 3.5

