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


(define (weight p)
  (let ((i (car p)) (j (cadr p)))
    (+ (square i) (square j))))

;; Only the following functions are different from ex3.71
(define (dup-weight-pairs-from pairs snd-prev-pair prev-pair)
  (let ((cur-pair (stream-car pairs))
	(cur-weight (weight (stream-car pairs))))
    
    (if (and (not (null? snd-prev-pair))
	     (not (null? prev-pair))
	     (= (weight snd-prev-pair)
		(weight prev-pair)
		cur-weight))
	(cons-stream (list snd-prev-pair prev-pair cur-pair)
		     (dup-weight-pairs-from (stream-cdr pairs)
					    prev-pair cur-pair))
	(dup-weight-pairs-from (stream-cdr pairs) prev-pair cur-pair))))

      
(define ways-of-sum-of-two-squares
  (stream-map (lambda (ps) (list (weight (car ps)) ps))
	      (dup-weight-pairs-from (weighted-pairs integers integers
						     weight) '() '())))

(show-stream ways-of-sum-of-two-squares 6)

;; (325 ((1 18) (6 17) (10 15)))
;; (425 ((5 20) (8 19) (13 16)))
;; (650 ((5 25) (11 23) (17 19)))
;; (725 ((7 26) (10 25) (14 23)))
;; (845 ((2 29) (13 26) (19 22)))
;; (850 ((3 29) (11 27) (15 25)))
