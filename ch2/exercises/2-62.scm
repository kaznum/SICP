;; Answer
(define (union-set set1 set2)
  (cond ((null? set1) set2)
	((null? set2) set1)
	(else
	 (let ((e1 (car set1))
	       (e2 (car set2)))
	   (cond ((< e1 e2) (cons e1 (union-set (cdr set1) set2)))
		 ((= e1 e2) (cons e1 (union-set (cdr set1) (cdr set2))))
		 ((> e1 e2) (cons e2 (union-set set1 (cdr set2)))))))))


;; TEST
(union-set '(1 2 5) '(1 2 3 4))
(union-set '(1 2 3 5) '(3 4))
