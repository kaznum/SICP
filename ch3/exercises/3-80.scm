(define (add-streams s1 s2)
  (cons-stream (+ (stream-car s1) (stream-car s2)) (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (scale-stream s m)
  (stream-map (lambda (x) (* m x)) s))

(define (integral delayed-integrand initial-value dt)
  (define int
    (cons-stream initial-value
		 (let ((integrand (force delayed-integrand)))
		   (add-streams (scale-stream integrand dt)
				int))))
  int)

;; Answer

(define (RLC R L C dt)
  (lambda (vC0 iL0)
    (define iL
      (integral (delay diL) iL0 dt))
    (define dvC
      (scale-stream iL (/ -1 C)))
    (define vC
      (integral (delay dvC) vC0 dt))
    (define diL
      (add-streams (scale-stream vC (/ 1 L)) (scale-stream iL (- (/ R L)))))
    (cons vC iL)))



;; TEST
(define RLC1 (RLC 1 1 0.2 0.1))
(define vL-iL (RLC1 10 0))

(define (show-vi-stream vi n)
  (if (zero? n)
      'done
      (let ((v (car vi))
	    (i (cdr vi)))
	(begin
	  (newline)
	  (display (cons (stream-car v) (stream-car i)))
	  (show-vi-stream (cons (stream-cdr v) (stream-cdr i)) (- n 1))))))

(show-vi-stream vL-iL 10)

;; (10 . 0)
;; (10 . 1.)
;; (9.5 . 1.9)
;; (8.55 . 2.66)
;; (7.220000000000001 . 3.249)
;; (5.5955 . 3.6461)
;; (3.77245 . 3.84104)
;; (1.8519299999999999 . 3.834181)
;; (-.0651605000000004 . 3.6359559)
;; (-1.8831384500000004 . 3.2658442599999997)
