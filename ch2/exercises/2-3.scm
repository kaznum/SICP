;; commonly used procedures
(define (make-segment start-point end-point) (cons start-point end-point))
(define (start-point seg) (car seg))
(define (end-point seg) (cdr seg))

(define (make-point x y) (cons x y))
(define (x-point p) (car p))
(define (y-point p) (cdr p))


;;
;; common procedures which are used abstractly
;; 
(define (perimeter rect)
  (* 2 (+ (width rect) (height rect))))

(define (area rect)
  (* (width rect) (height rect)))


;;
;; Implementation A
;; Represented with 2 corners
;;
(define (make-rectangle start end) (make-segment start end))

(define (start rect) (car rect))
(define (end rect) (cdr rect))

(define (width rect)
  (abs (- (x-point (start rect)) (x-point (end rect)))))
(define (height rect)
  (abs (- (y-point (start rect)) (y-point (end rect)))))

;; TEST A
(define rect (make-rectangle (make-point 1 2)
			     (make-point 3 8)))
(perimeter rect)
(area rect)

;;
;; Implementation B
;; Represented with width and heght
;;
(define (make-rectangle-wh width height)
  (cons width height))

(define (width rect) (car rect))
(define (height rect) (cdr rect))


;; TEST B
(define rect-wh (make-rectangle-wh 3 5))
(perimeter rect-wh)
(area rect-wh)

