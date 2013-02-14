;; Given
(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2)
  (make-vect (+ (xcor-vect v1) (xcor-vect v2))
	     (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2)
  (make-vect (- (xcor-vect v1) (xcor-vect v2))
	     (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect s v)
  (make-vect (* s (xcor-vect v)) (* s (ycor-vect v))))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
			   (edge1-frame frame))
	       (scale-vect (ycor-vect v)
			   (edge2-frame frame))))))

;; Answer 1
(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame frame)
  (car frame))
(define (edge1-frame frame)
  (cadr frame))
(define (edge2-frame frame)
  (caddr frame))

;; TEST for Answer 1
(define frame (make-frame (make-vect 1 2) (make-vect 2 3) (make-vect 3 4)))
(origin-frame frame)
(edge1-frame frame)
(edge2-frame frame)

((frame-coord-map frame) (make-vect 1 2))
;; (9 13)

;; Answer 2
(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame frame)
  (car frame))
(define (edge1-frame frame)
  (car (cdr frame)))
(define (edge2-frame frame)
  (cddr frame))

;; TEST for Answer 2
(define frame (make-frame (make-vect 1 2) (make-vect 2 3) (make-vect 3 4)))
(origin-frame frame)
(edge1-frame frame)
(edge2-frame frame)

((frame-coord-map frame) (make-vect 1 2))
;; (9 13)

