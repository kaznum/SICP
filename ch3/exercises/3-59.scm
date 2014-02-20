;; a.
;;; Answer 1
(define (integrate-series c)
  (define (powered-coefficient c n)
    (cons-stream (/ (stream-car c) n)
		 (powered-coefficient (stream-cdr c) (+ n 1))))
  (powered-coefficient c 1))

;;; Answer 2
;;; some function has already defined in previous sections and exercises
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))
(define integers
  (integers-starting-from 1))
(define (mul-streams s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      the-empty-stream
      (cons-stream (* (stream-car s1) (stream-car s2))
		   (mul-streams (stream-cdr s1) (stream-cdr s2)))))
;;; the Answer is
(define (invert-stream s)
  (stream-map (lambda (x) (/ 1 x)) s))

(define (integrate-series c)
  (mul-streams c (invert-stream integers)))

;; test
(define s (cons-stream 10 (cons-stream 11 (cons-stream 12 (cons-stream 13 the-empty-stream)))))
(define a (integrate-series s))
(stream-ref a 0)
;; 10
(stream-ref a 1)
;; 11/2
(stream-ref a 2)
;; 4
(stream-ref a 3)
;; 13/4

;; b.
(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(define cosine-series
  (cons-stream 1 (stream-map (lambda (x) (* -1 x)) (integrate-series sine-series))))
  
(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

;; test
(stream-ref cosine-series 0)
(stream-ref cosine-series 1)
(stream-ref cosine-series 2)
(stream-ref cosine-series 3)
(stream-ref cosine-series 4)

(stream-ref sine-series 0)
(stream-ref sine-series 1)
(stream-ref sine-series 2)
(stream-ref sine-series 3)
(stream-ref sine-series 4)
(stream-ref sine-series 5)
