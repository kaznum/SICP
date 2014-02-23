(define (sqrt-improve guess x)
  (average guess (/ x guess)))
(define (average x y)
  (/ (+ x y) 2.0))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
		 guesses)))
  guesses)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

;;; Answer

(define (stream-limit s tolerance)
  (let ((val1 (stream-car s))
	(val2 (stream-car (stream-cdr s))))
    (if (> tolerance  (abs (- val2 val1)))
	val2
	(stream-limit (stream-cdr s) tolerance))))

(sqrt 5 0.01)
;Value: 2.2360688956433634

(stream-ref (sqrt-stream 5) 0)
;Value: 1.
(stream-ref (sqrt-stream 5) 1)
;Value: 3.
(stream-ref (sqrt-stream 5) 2)
;Value: 2.3333333333333335
(stream-ref (sqrt-stream 5) 3)
;Value: 2.238095238095238
(stream-ref (sqrt-stream 5) 4)
;Value: 2.2360688956433634

(sqrt 5 0.0000000000000000001)
;Value: 2.23606797749979
