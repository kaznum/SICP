;; preparation
(define (mul-interval x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
        (p2 (* (lower-bound x) (upper-bound y)))
        (p3 (* (upper-bound x) (lower-bound y)))
        (p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
                   (max p1 p2 p3 p4))))

(define (make-interval a b) (cons a b))
(define (upper-bound x) (max (car x) (cdr x)))
(define (lower-bound x) (min (car x) (cdr x)))


;; redefine mul-interval procedure
(define (mul-interval x y)
  (define (sign x)
    (cond ((and (> (lower-bound x) 0) (> (upper-bound x) 0)) 1)
	  ((and (< (lower-bound x) 0) (< (upper-bound x) 0)) -1)
	  (else 0)))

  (cond ((> (sign x) 0)
	 (cond ((> (sign y) 0)
		(make-interval (* (lower-bound x) (lower-bound y))
			       (* (upper-bound x) (upper-bound y))))
	       ((= (sign y) 0)
		(make-interval (* (upper-bound x) (lower-bound y))
			       (* (upper-bound x) (upper-bound y))))
	       ((< (sign y) 0)
		(make-interval (* (upper-bound x) (lower-bound y))
			       (* (lower-bound x) (upper-bound y))))))
	((= (sign x) 0)
	 (cond ((> (sign y) 0)
		(mul-interval y x))
	       ((= (sign y) 0)
		(make-interval (min
				(* (upper-bound x) (lower-bound y))
				(* (lower-bound x) (upper-bound y)))
			       (max
				(* (upper-bound x) (upper-bound y))
				(* (lower-bound x) (lower-bound y)))))
	       ((< (sign y) 0)
		(make-interval (* (lower-bound x) (upper-bound y))
			       (* (upper-bound x) (upper-bound y))))))
	(else
	 (cond ((> (sign y) 0)
		(mul-interval y x))
	       ((= (sign y) 0)
		(mul-interval y x))
	       ((< (sign y) 0)
		(make-interval (* (upper-bound x) (upper-bound y))
			       (* (lower-bound x) (lower-bound y))))))))

(mul-interval (make-interval 10 10) (make-interval 3 5))
(mul-interval (make-interval 10 10) (make-interval -3 5))
(mul-interval (make-interval 10 10) (make-interval -3 -5))

(mul-interval (make-interval -10 10) (make-interval 3 5))
(mul-interval (make-interval -10 10) (make-interval -3 5))
(mul-interval (make-interval -10 10) (make-interval -3 -5))
	 
(mul-interval (make-interval -10 -10) (make-interval 3 5))
(mul-interval (make-interval -10 -10) (make-interval -3 5))
(mul-interval (make-interval -10 -10) (make-interval -3 -5))

