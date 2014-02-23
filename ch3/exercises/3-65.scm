;; From the code samples of the section
(define (partial-sums s)
  (cons-stream (stream-car s)
	       (stream-map (lambda (x) (+ (stream-car s) x))
			   (partial-sums (stream-cdr s)))))

(define (euler-transform s)
  (let ((s0 (stream-ref s 0))
	(s1 (stream-ref s 1))
	(s2 (stream-ref s 2)))
    (cons-stream (- s2 (/ (square (- s2 s1))
			  (+ s0 (* -2 s1) s2)))
		 (euler-transform (stream-cdr s)))))

(define (make-tableau transform s)
  (cons-stream s (make-tableau transform (transform s))))

(define (accelerated-sequence transform s)
  (stream-map stream-car (make-tableau transform s)))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

;; from ex3.64(modified)
(define (stream-limit s tolerance times)
  (let ((val1 (stream-car s))
	(val2 (stream-car (stream-cdr s))))
    (if (> tolerance  (abs (- val2 val1)))
	(begin
	  (newline)
	  (display times)
	  (display " times computed.")
	  val2)
	(stream-limit (stream-cdr s) tolerance (+ 1 times)))))

 ;; Answer

(define (ln2-summands n)
  (cons-stream (/ 1.0 n)
	       (stream-map - (ln2-summands (+ n 1)))))
(define ln2-stream
  (partial-sums (ln2-summands 1)))

(stream-limit ln2-stream 0.0001 0)
;; 9998 times computed.
;; ;Value: .6930971830599453

(stream-limit (euler-transform ln2-stream) 0.0001 0)
;; 11 times computed.
;; ;Value: .6931879423258733
;; -> 908 times faster

(stream-limit (accelerated-sequence euler-transform ln2-stream) 0.0001 0)
;; 3 times computed.
;; ;Value: .6931471960735491
;; -> 3.67 times faster than euler transform.
;; -> 3300 times faster than the original one.
