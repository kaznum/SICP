(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
	       (add-streams (stream-map (lambda (x) (* x (stream-car s1)))
					(stream-cdr s2))
			    (mul-series (stream-cdr s1) s2))))

;; 1/S = X
;; X*S = 1
;; X*(1+Sr) = 1
;; X = 1 - X*Sr


;; Answer
(define (negate-stream s)
  (stream-map (lambda (x) (* -1 x)) s))
(define (invert-unit-series s)
  (cons-stream 1
	       (negate-stream (mul-series (invert-unit-series s)
					  (stream-cdr s)))))

;; test

(define s (cons-stream 1 (cons-stream 2 (cons-stream 3 the-empty-stream))))

(define x (invert-unit-series s))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))
(show-stream x 3)
;; 1
;; -2
;; 1
;; ;Value: done
