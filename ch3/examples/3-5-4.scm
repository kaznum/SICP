;; dy/dt = f(y)

;;;; The following code does not work because dy is defined the next line which is needed in (define y ..)
;; (define (solve f y0 dt)
;;   (define y (integral dy y0 dt))
;;   (define dy (stream-map f y))
;;   y)

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

(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; for dy/dt = y with y(0) = 1, which is y = exp^t
(stream-ref (solve (lambda (y) y)
		   1
		   0.001)
	    1000)
;Value: 2.716923932235896

;;; Normal-order evaluation

;; no codes

