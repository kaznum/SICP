;; from ex3.59
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers
  (integers-starting-from 1))
(define (mul-streams s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      the-empty-stream
      (cons-stream (* (stream-car s1) (stream-car s2))
		   (mul-streams (stream-cdr s1) (stream-cdr s2)))))
(define (invert-stream s)
  (stream-map (lambda (x) (/ 1 x)) s))

(define (integrate-series c)
  (mul-streams c (invert-stream integers)))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (stream-map (lambda (x) (* -1 x)) (integrate-series sine-series))))
  
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;;; defined previously
(define (add-streams s1 s2) (stream-map + s1 s2))
;;; answer

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
	       (add-streams (stream-map (lambda (x) (* x (stream-car s1))) (stream-cdr s2))
			    (mul-series (stream-cdr s1) s2))))

(define one (add-streams (mul-series sine-series sine-series)
			 (mul-series cosine-series cosine-series)))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))
(show-stream one 20)
;; 1
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; ;Value: done





