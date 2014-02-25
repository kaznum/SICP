;; from text
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

(define (triples s t u)
  (cons-stream (list (stream-car s) (stream-car t) (stream-car u))
	       (interleave
		(stream-map (lambda (x) (cons (stream-car s) x))
			    (stream-map (lambda (y) (list (stream-car t) y))
					(stream-cdr u)))
		(interleave
		 (stream-map (lambda (x) (cons (stream-car s) x))
			     (pairs (stream-cdr t) (stream-cdr u)))
		 (triples (stream-cdr s) (stream-cdr t) (stream-cdr u))))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (stream-map (lambda (x) (list (stream-car s) x))
		(stream-cdr t))
    (pairs (stream-cdr s) (stream-cdr t)))))

(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))

(define integers
  (integers-from 1))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

(define (pythagoreans s t u)
  (stream-filter (lambda (sides)
		   (let ((l1 (car sides))
			 (l2 (cadr sides))
			 (l3 (caddr sides)))
		     (zero? (- (+ (square l1) (square l2)) (square l3)))))
		 (triples s t u)))

;; test
(define int-triples (triples integers integers integers))

(show-stream int-triples 100)

(define int-pythagoreans  (pythagoreans integers integers integers))
(show-stream int-pythagoreans 5)
