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
    (+ (* i i i) (* j j j))))

(define (dup-weight-pairs-from pairs prev-pair)
  (let ((cur-pair (stream-car pairs))
	(cur-weight (weight (stream-car pairs))))
    (if (and (not (null? prev-pair))
	     (= (weight prev-pair) cur-weight))
	(cons-stream (list prev-pair cur-pair)
		     (dup-weight-pairs-from (stream-cdr pairs)
					    cur-pair))
	(dup-weight-pairs-from (stream-cdr pairs) cur-pair))))

      
(define ramanujans
  (stream-map (lambda (ps) (weight (car ps)))
	      (dup-weight-pairs-from (weighted-pairs integers integers
						     weight) '())))

(show-stream ramanujans 6)

;; 1729
;; 4104
;; 13832
;; 20683
;; 32832
;; 39312
