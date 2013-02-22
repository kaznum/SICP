;; Given
(define (element-of-set? x set)
  (cond ((null? set) false)
	((= x (car set)) true)
	((< x (car set)) false)
	(else (element-of-set? x (cdr set)))))

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
	(cond ((= x1 x2)
	       (cons x1 (intersection-set (cdr set1)
					  (cdr set2))))
	      ((< x1 x2)
	       (intersection-set (cdr set1) set2))
	      ((> x1 x2)
	       (intersection-set set1 (cdr set2)))))))

;; Answer
(define (adjoin-set x set)
  (cond ((null? set) (cons x set))
	((= x (car set)) set)
	((> x (car set)) (cons (car set) (adjoin-set x (cdr set))))
	(else (cons x set))))
;; TEST
(adjoin-set 3 '(1 2 3 4))
(adjoin-set 3 '())
(adjoin-set 3 '(4 5 6 7))
(adjoin-set 5 '(1 2 3 4 6 7))


;; Compared with unordered representation, the order of the number of step is theta(n)
;; which is the same as that of unordered representation, but the comparison count
;; between given value and the elements of the set would be on the average half
