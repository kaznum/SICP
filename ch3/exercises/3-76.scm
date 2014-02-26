;; Answer
(define (stream-map f s1 s2)
  (cons-stream (f (stream-car s1) (stream-car s2))
	       (stream-map f (stream-cdr s1) (stream-cdr s2))))

(define (smooth s)
  (stream-map (lambda (a b) (/ (+ a b) 2)) s (cons-stream 0 s)))
  
(define (make-zero-crossings input-stream)
  (let ((smoothed (smooth input-stream)))
    (stream-map sign-change-detector
		smoothed
		(cons-stream 0 smoothed))))

(define zero-crossings
  (make-zero-crossings sense-data))

(define (sign-change-detector a b)
  (cond ((< (* a b) 0)
	 (if (> a b) 1 -1))
	((> (* a b) 0) 0)
	((< a 0) -1)
	((< b 0) 1)
	(else 0)))

(define sense-list (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4))
(define (make-stream ls)
  (if (null? ls)
      the-empty-stream
      (cons-stream (car ls) (make-stream (cdr ls)))))
(define sense-data (make-stream sense-list))


;; TEST
(show-stream zero-crossings 12)
;; 0
;; 0
;; 0
;; 0
;; 0
;; 0
;; -1
;; 0
;; 0
;; 0
;; 0
;; 1
