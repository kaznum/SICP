(define (scale-stream s num)
  (stream-map (lambda (x) (* num x)) s))

(define (integrate-series c)
  (define (powered-coefficient c n)
    (cons-stream (/ (stream-car c) n)
		 (powered-coefficient (stream-cdr c) (+ n 1))))
  (powered-coefficient c 1))

(define cosine-series
  (cons-stream 1 (stream-map (lambda (x) (* -1 x)) (integrate-series sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

(define (add-streams s1 s2) (stream-map + s1 s2))
(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
	       (add-streams (stream-map (lambda (x) (* x (stream-car s1)))
					(stream-cdr s2))
			    (mul-series (stream-cdr s1) s2))))

(define (negate-stream s)
  (stream-map (lambda (x) (* -1 x)) s))

(define (invert-unit-series s)
  (cons-stream 1
	       (negate-stream (mul-series (invert-unit-series s)
					  (stream-cdr s)))))

;; Answer
;; invert-unit-series can be applied when the series' constant is 1
(define (div-series s1 s2)
  (let ((den0 (stream-car s2)))
    (if (zero? den0)
	(error "den0 must not be 0." den0)
	(mul-series s1
		    (scale-stream (invert-unit-series (scale-stream s2 (/ 1 den0)))
				  den0)))))

(define tangent-series
  (div-series sine-series cosine-series))

(show-stream tangent-series 10)

;; 0
;; 1
;; 0
;; 1/3
;; 0
;; 2/15
;; 0
;; 17/315
;; 0
;; 62/2835
