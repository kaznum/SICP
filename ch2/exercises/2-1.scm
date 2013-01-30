;;;; preparation
(define (numer x) (car x))
(define (denom x) (cdr x))

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
     (* (numer y) (denom x))))

;;; define make-rat which supports minus rational value
(define (make-rat n d)
  (let ((abs-n (abs n))
	(abs-d (abs d))
	(g (gcd (abs n) (abs d)))
	(sign (if (< (* n d) 0) -1 1)))
    (cons (* sign (/ abs-n g)) (/ abs-d g))))
(print-rat (add-rat one-third one-third))

(define minus-two-third (make-rat -2 3))

(print-rat (add-rat minus-two-third one-third))
(print-rat (sub-rat minus-two-third one-third))
(print-rat (mul-rat minus-two-third one-third))
(print-rat (div-rat minus-two-third one-third))
(print-rat (add-rat minus-two-third minus-two-third))
(print-rat (sub-rat minus-two-third minus-two-third))
(print-rat (mul-rat minus-two-third minus-two-third))
(print-rat (div-rat minus-two-third minus-two-third))


