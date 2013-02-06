(define (fringe l)
  (cond ((null? l) l)
	((list? l) (append (fringe (car l)) (fringe (cdr l))))
	(else (list l))))

;; TEST
(define x (list (list 1 2) (list 3 4)))
(fringe x)
(fringe (list x x))
(fringe (list (cons x x) x))

