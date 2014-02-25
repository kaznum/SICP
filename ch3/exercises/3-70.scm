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

;; Answer
(define (merge-weighted s1 s2 weight)
  (cond ((stream-null? s1) s2)
	((stream-null? s2) s1)
	((<= (weight (stream-car s1)) (weight (stream-car s2)))
	 (cons-stream (stream-car s1) (merge-weighted (stream-cdr s1) s2 weight)))
	((> (weight (stream-car s1)) (weight (stream-car s2)))
	 (cons-stream (stream-car s2) (merge-weighted s1 (stream-cdr s2) weight)))))

(define (weighted-pairs s t weight)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (merge-weighted
    (stream-map (lambda (x) (list (stream-car s) x))
		(stream-cdr t))
    (weighted-pairs (stream-cdr s) (stream-cdr t) weight)
    weight)))

;; a.
(define (ordered-pairs1 s t)
  (weighted-pairs s t (lambda (p) (+ (car p) (cadr p)))))

(show-stream (ordered-pairs1 integers integers) 20)

;; (1 1)
;; (1 2)
;; (1 3)
;; (2 2)
;; (1 4)
;; (2 3)
;; (1 5)
;; (2 4)
;; (3 3)
;; (1 6)
;; (2 5)
;; (3 4)
;; (1 7)
;; (2 6)
;; (3 5)
;; (4 4)
;; (1 8)
;; (2 7)
;; (3 6)
;; (4 5)

;; b.
(define (ordered-pairs2 s t)
  (define (filter ps)
    (stream-filter (lambda (p)
		     (let ((i (car p))
			   (j (cadr p)))
		       (not (or (zero? (remainder i 2))
				(zero? (remainder i 3))
				(zero? (remainder i 5))
				(zero? (remainder j 2))
				(zero? (remainder j 3))
				(zero? (remainder j 5))))))
		   ps))

  (define (weight p)
    (+ (* 2 (car p))
       (* 5 (cadr p))
       (* 5 (car p) (cadr p))))

  (filter (weighted-pairs s t weight)))


(show-stream (ordered-pairs2 integers integers) 20)
;; (1 1)
;; (1 7)
;; (1 11)
;; (1 13)
;; (1 17)
;; (1 19)
;; (1 23)
;; (1 29)
;; (7 7)
;; (1 31)
;; (1 37)
;; (1 41)
;; (1 43)
;; (7 11)
;; (1 47)
;; (1 49)
;; (1 53)
;; (7 13)
;; (1 59)
;; (1 61)
