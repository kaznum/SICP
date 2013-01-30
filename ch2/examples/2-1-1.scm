(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x) (denom y))))

(define (sub-rat x y)
  (make-rat (- (* (numer x) (denom y))
	       (* (numer y) (denom x)))
	    (* (denom x) (denom y))))

(define (mul-rat x y)
  (make-rat (* (numer x) (numer y))
	    (* (denom x) (denom y))))

(define (div-rat x y)
  (make-rat (* (numer x) (denom y))
	    (* (denom x) (numer y))))


(define (equal-rat? x y)
  (= (* (numer x) (denom y))
     (* (denom x) (numer y))))


;; Pair
(define x (cons 1 2))
(car x)
(cdr x)

(define x (cons 1 2))
(define y (cons 3 4))
(define z (cons x y))

(car (car z))
(car (cdr z))

;; Representing rational numbers

;; to be continued
