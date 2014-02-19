(define (scale-stream stream factor)
  (stream-map (lambda (x) (* x factor))
              stream))

(define (merge s1 s2)
  (cond ((stream-null? s1) s2)
	((stream-null? s2) s1)
	(else
	 (let ((s1car (stream-car s1))
	       (s2car (stream-car s2)))
	   (cond ((< s1car s2car)
		  (cons-stream
		   s1car
		   (merge (stream-cdr s1) s2)))
		 ((> s1car s2car)
		  (cons-stream
		   s2car
		   (merge s1 (stream-cdr s2))))
		 (else
		  (cons-stream
		   s1car
		   (merge (stream-cdr s1) (stream-cdr s2)))))))))

(define S (cons-stream 1 (merge (scale-stream S 2)
				(merge (scale-stream S 3)
				       (scale-stream S 5)))))

(define (show-stream-to s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream-to (stream-cdr s) (- n 1)))))

(show-stream-to s 15)
;; 1
;; 2
;; 3
;; 4
;; 5
;; 6
;; 8
;; 9
;; 10
;; 12
;; 15
;; 16
;; 18
;; 20
;; 24

