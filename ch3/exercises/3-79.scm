;; from text
(define (stream-map2 f s1 s2)
  (cons-stream (f (stream-car s1) (stream-car s2))
	       (stream-map2 f (stream-cdr s1) (stream-cdr s2))))

(define (scale-stream s m)
  (stream-map (lambda (x) (* m x)) s))

(define (add-streams s1 s2)
  (stream-map2 (lambda (x y) (+ x y)) s1 s2))

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream
     initial-value
     (let ((integrand (force delayed-integrand)))
       (add-streams (scale-stream integrand dt) int))))
  int)

(define (solve-2nd f dt y0 dy0)
  (define y (integral (delay dy) y0 dt))
  (define dy (integral (delay ddy) dy0 dt))
  (define ddy (stream-map f dy y))
  y)


;; for (f(dy/dt, y) = y)
;;  this means y = exp^t
;; y0 = 1
;; dy0 = 1

(stream-ref (solve-2nd (lambda (dy y) y) 0.0001 1 1) 10000)
;; 2.7181459268252266
