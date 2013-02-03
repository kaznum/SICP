(define (add-interval x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
		 (+ (upper-bound x) (upper-bound y))))

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


(define (make-center-width c w)
  (make-interval (-c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

(define (make-center-percent c p)
  (let ((w (* c (/ p 100))))
    (make-interval (- c w) (+ c w))))

(define (percent x)
  (* (/ (width x) (center x)) 100))

  
;; parallel resistor
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
		(add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
		  (add-interval (div-interval one r1)
				(div-interval one r2)))))

(define (print-center-percent x)
  (newline)
  (display (center x))
  (display " +- ")
  (display (percent x))
  (display "%")
  (newline))
	   
(print-center-percent
 (par1 (make-center-percent 5 2.0)
       (make-center-percent 7 3.0)))
;; 2.9241354820821392 +- 7.570562352882451%

(print-center-percent
 (par2 (make-center-percent 5 2.0)
       (make-center-percent 7 3.0)))
;; 2.9165957281213366 +- 2.41678827855933%

;; both center value are same,
;; but tolerances are different from each other.
;; because the numbers of usage of the parameters in the equation
;; are different


;; A/A
(print-center-percent (div-interval (make-center-percent 5 2.0)
				    (make-center-percent 5 2.0)))
;; 1.000800320128051 +- 3.9984006397440868%
;; The center value is 1, which is correct
;; tolerance is double of the one of A (This is correct.)


;; A/B
(print-center-percent (div-interval
		       (make-center-percent 5 2.0)
		       (make-center-percent 7 3.0)))
;; .7153581080114961 +- 4.997001798920644%
;; tolerance is the sum of the tolerances of the elements
;; (This is correct.)
