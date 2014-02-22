;;; Formulating iterations as stream process
(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (average a b)
  (/ (+ a b) 2))

(define (sqrt-stream x)
  (define guesses
    (cons-stream
     1.0
     (stream-map (lambda (guess) (sqrt-improve guess x))
		 guesses)))
  guesses)

(display-stream (sqrt-stream 2))

(define (pi-summands n)
  (cons-stream (/ 1.0 n)
	       (stream-map - (pi-summands (+ n 2)))))

(define (partial-sums s)
  (cons-stream (stream-car s) (stream-map (lambda (x) (+ (stream-car s) x)) (partial-sums (stream-cdr s)))))

(define pi-stream
  (scale-stream (partial-sums (pi-summands 1)) 4))

(display-stream pi-stream)

(stream-ref pi-stream 7)
;Value: 3.017071817071817

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
	(s1 (stream-ref s 1))
	(s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
			  (+ s0 (* -2 s1) s2)))
		 (euler-transform (stream-cdr s)))))

(stream-ref (euler-transform pi-stream) 7)
;Value: 3.1412548236077646

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(stream-ref (accelerated-sequence euler-transform pi-stream) 7)
;Value: 3.141592653589777


;;; Infinite streams of pairs

;; to be continued
