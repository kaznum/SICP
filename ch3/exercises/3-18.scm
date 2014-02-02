(define (occured? exp pairs)
  (any (lambda (x) (eq? exp x)) pairs))

(define (loop? exp pairs)
  (cond ((not (pair? exp))
	 false)
	((occured? exp pairs)
	 true)
	(else
	 (let ((new-pairs (cons exp pairs)))
	   (or (loop? (car exp) new-pairs) (loop? (cdr exp) new-pairs))))))

(define (loop-exists? exp)
  (loop? exp '()))


(loop-exists? '(a b c d))
;Value: #f

;;; loop in cdr
(define p1 '(x y z))
(loop-exists? (list 'a p1 p1))
;Value: #f
(set-cdr! (cddr p1) p1)
(loop-exists? p1)
;Value: #t

;;; loop in car
(define p2 '(x y z))
(loop-exists? p2)
;Value: #f
(set-car! (cdr p2) p2)
(loop-exists? p2)
;Value: #t

