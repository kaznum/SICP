(define (add-streams s1 s2)
  (cons-stream (+ (stream-car s1) (stream-car s2)) (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (scale-stream s m)
  (stream-map (lambda (x) (* m x)) s))

(define (integral integrand initial-value dt)
  (define int
    (cons-stream initial-value
		 (add-streams (scale-stream integrand dt)
			      int)))
  int)

;; Answer
(define (RC R C dt)
  (lambda (currents v0)
    (add-streams (scale-stream (integral currents v0 dt) (/ 1 C))
		 (scale-stream currents R))))


;; TEST
(define RC1 (RC 5 1 0.5))
(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))
(define integers (integers-from 1))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

(define voltages (RC1 integers 3))

(show-stream voltages 20)

;; 8
;; 13.5
;; 19.5
;; 26.
;; 33.
;; 40.5
;; 48.5
;; 57.
;; 66.
;; 75.5
;; 85.5
;; 96.
;; 107.
;; 118.5
;; 130.5
;; 143.
;; 156.
;; 169.5
;; 183.5
;; 198.
