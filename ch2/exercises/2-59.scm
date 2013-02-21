;; Given
(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))


(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

;; Answer
(define (union-set set1 set2)
  (cond ((null? set1) set2)
	((null? set2) set1)
	(else (union-set (cdr set1) (adjoin-set (car set1) set2)))))

;; TEST
(union-set '(1 2 3 4 5) '(3 2 1 0 -1))
