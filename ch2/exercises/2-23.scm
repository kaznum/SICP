(define (for-each f l)
  (cond ((null? l) #t)
	(else (f (car l)) (for-each f (cdr l)))))


(for-each (lambda (x) (newline) (display x)) (list 1 2 3 4 5))
