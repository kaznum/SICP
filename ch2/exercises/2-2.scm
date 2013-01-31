(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

;; definition segment
(define (make-segment start-point end-point)
  (cons start-point end-point))

(define (start-point seg)
  (car seg))

(define (end-point seg)
  (cdr seg))

;; definition of point
(define (make-point x y)
  (cons x y))

(define (x-point p)
  (car p))

(define (y-point p)
  (cdr p))

(define (midpoint-segment seg)
  (let ((start-x (x-point (start-point seg)))
	(start-y (y-point (start-point seg)))
	(end-x (x-point (end-point seg)))
	(end-y (y-point (end-point seg))))
    (make-point (/ (+ end-x start-x) 2) (/ (+ end-y start-y) 2))))


;; TEST
(print-point (midpoint-segment (make-segment (make-point 2 3)
					     (make-point 9 9))))
