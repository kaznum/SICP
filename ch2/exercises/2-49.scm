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

(define (make-segment v1 v2) (cons v1 v2))

(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))


(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))
(define (origin-frame frame)
  (car frame))
(define (edge1-frame frame)
  (car (cdr frame)))
(define (edge2-frame frame)
  (cddr frame))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
     (origin-frame frame)
     (add-vect (scale-vect (xcor-vect v)
			   (edge1-frame frame))
	       (scale-vect (ycor-vect v)
			   (edge2-frame frame))))))

(define (segments->painter segment-list)
  (lambda (frame)
    (for-each
     (lambda (segment)
       (draw-line
	((frame-coord-map frame) (start-segment segment))
	((frame-coord-map frame) (end-segment segment))))
     segment-list)))


;; Answer

;; a

(define (outline-of-frame frame)
  ((segments->painter (list (make-segment (make-vect 0 0) (make-vect 0 1))
			    (make-segment (make-vect 0 1) (make-vect 1 1))
			    (make-segment (make-vect 1 1) (make-vect 1 0))
			    (make-segment (make-vect 1 0) (make-vect 0 0))))
   frame))

;; b

(define (x-of-frame frame)
  ((segments->painter (list (make-segment (make-vect 0 0) (make-vect 1 1))
			    (make-segment (make-vect 0 1) (make-vect 1 0))))
   frame))

;; c

(define (diamond-of-frame frame)
  ((segments->painter (list (make-segment (make-vect 0.5 0) (make-vect 0 0.5))
			    (make-segment (make-vect 0 0.5) (make-vect 0.5 1.0))
			    (make-segment (make-vect 0.5 1.0) (make-vect 1 0.5))
			    (make-segment (make-vect 1.0 0.5) (make-vect 0.5 1.0))))
   frame))

;; d

(define (wave frame)
  ((segments->painter (list
		       ;; leftside
		       ;;;; head
		       (make-segment (make-vect 0.4 0) (make-vect 0.3 0.2))
		       (make-segment (make-vect 0.3 0.2) (make-vect 0.4 0.4))
		       ;;;; shoulder
		       (make-segment (make-vect 0.4 0.4) (make-vect 0.3 0.4))
		       ;;;; arm-top
		       (make-segment (make-vect 0.3 0.4) (make-vect 0.15 0.45))
		       (make-segment (make-vect 0.15 0.45) (make-vect 0 0.2))
		       ;;;; arm-bottom
		       (make-segment (make-vect 0 0.4) (make-vect 0.15 0.65))
		       (make-segment (make-vect 0.15 0.65) (make-vect 0.3 0.45))
		       (make-segment (make-vect 0.3 0.5) (make-vect 0.35 0.5))
		       ;; leg-outside
		       (make-segment (make-vect 0.35 0.5) (make-vect 0.2 1.0))
		       ;; leg-inside
		       (make-segment (make-vect 0.35 0.5) (make-vect 0.2 1.0))
		       ;;;; leg-inside
		       (make-segment (make-vect 0.5 0.7) (make-vect 0.4 1.0))
		       ;; rightside
		       ;;;; head
		       (make-segment (make-vect 0.6 0) (make-vect 0.7 0.2))
		       (make-segment (make-vect 0.7 0.2) (make-vect 0.6 0.4))
		       ;;;; shoulder
		       (make-segment (make-vect 0.6 0.4) (make-vect 0.7 0.4))
		       ;;;; arm-top
		       (make-segment (make-vect 0.7 0.4) (make-vect 1.0 0.6))
		       ;;;; arm-bottom
		       (make-segment (make-vect 1.0 0.8) (make-vect 0.6 0.5))
		       ;;;; leg-outside
		       (make-segment (make-vect 0.6 0.5) (make-vect 0.8 1.0))
		       ;;;; leg-inside
		       (make-segment (make-vect 0.5 0.7) (make-vect 0.6 1.0))))
   
   frame))

