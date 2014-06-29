;; The lazier list (in this section) does not need
;; 'delay', 'force', which makes us not to take care
;; about the timing of delaying and forcing.
;; This means we don't have to care about the difference
;; the object is a promise or not, delay or force, etc
;; we have only to use the 'cons' list for infinite list, tree, etc.


;;
;; Ex3.77
;;
;; With stream
(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

(define (integral delayed-integrand initial-value dt)
  (cons-stream
   initial-value
   (let ((integrand (force delayed-integrand)))
     (if (stream-null? integrand)
         the-empty-stream
         (integral (delay (stream-cdr integrand))
                   (+ (* dt (stream-car integrand))
                      initial-value)
                   dt)))))

(stream-ref (solve (lambda (y) y) 1 0.001)
            1000)

;; With Lazier cons (This section)
(define (solve f y0 dt)
  (define y (integral dy y0 dt))
  (define dy (map f y))
  y)

(define (integral integrand initial-value dt)
  (define int
    (cons initial-value
	  (add-lists int
		     (scale-list integrand dt))))
  int)


;;
;; Ex3.78
;;
;; With stream
(define (solve-2nd a b dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (add-streams (scale-stream dy a)
                           (scale-stream y b)))
  y)


;; With Lazier list
(define (solve-2nd a b dt y0 dy0)
  (define y (integral dy y0 dt))
  (define dy (integral ddy dy0 dt))
  (define ddy (add-lists (scale-list dy a)
                           (scale-list y b)))
  y)


