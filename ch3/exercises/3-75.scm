;; average should be calculated with native signals.
(define (make-zero-crossings input-stream last-avpt last-value)
  (let ((avpt (/ (+ (stream-car input-stream)
		    last-value)
		 2)))
    (cons-stream
     (sign-change-detector avpt last-avpt)
     (make-zero-crossings
      (stream-cdr input-stream) avpt (stream-car input-stream)))))

(define zero-crossings
  (make-zero-crossings sense-data 0 0))

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
