(cons (list 1 2) (list 3 4))

(define (count-leaves x)
  (cond ((null? x) 0)
	((not (pair? x)) 1)
	(else (+ (count-leaves (car x))
		 (count-leaves (cdr x))))))


(define x (cons (list 1 2) (list 3 4)))
(length x)
(count-leaves x)
(list x x)
;; (((1 2) 3 4) ((1 2) 3 4))
(length (list x x))
;; 2
(count-leaves (list x x))
;; 8


;;
;; Mapping over trees
;;
(define (scale-tree tree factor)
  (cond ((null? tree) '())
	((not (pair? tree)) (* tree factor))
	(else (cons (scale-tree (car tree) factor)
		    (scale-tree (cdr tree) factor)))))


(scale-tree (list 1 (list 2 (list 3 4) 5) (list 6 7)) 10)

(define (scale-tree tree factor)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (scale-tree sub-tree factor)
	     (* sub-tree factor)))
       tree))

