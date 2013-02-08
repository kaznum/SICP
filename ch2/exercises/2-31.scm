(define (square-tree tree) (tree-map square tree))

;; without higher-order procedures
(define (tree-map f tree)
  (cond ((null? tree) '())
	((not (pair? tree)) (f tree))
	(else (cons (tree-map f (car tree)) (tree-map f (cdr tree))))))

;; TEST
(square-tree (list 1
		   (list 2 (list 3 4) 5)
		   (list 6 7)))

;; using map
(define (tree-map f tree)
  (map (lambda (sub-tree)
	 (if (pair? sub-tree)
	     (tree-map f sub-tree)
	     (f sub-tree)))
       tree))

;; TEST
(square-tree (list 1
		   (list 2 (list 3 4) 5)
		   (list 6 7)))

