;; Given
(define (entry tree) (car tree))
(define (left-branch tree) (cadr tree))
(define (right-branch tree) (caddr tree))
(define (make-tree entry left right)
  (list entry left right))

;; The following procedure is not used because this is not cost-effective
;; (define (tree->list-1 tree)
;;   (if (null? tree)
;;       '()
;;       (append (tree->list-1 (left-branch tree))
;; 	      (cons (entry tree)
;; 		    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
	result-list
	(copy-to-list (left-branch tree)
		      (cons (entry tree)
			    (copy-to-list (right-branch tree)
					  result-list)))))
  (copy-to-list tree '()))


(define (list->tree elements)
  (car (partial-tree elements (length elements))))

(define (partial-tree elts n)
  (if (= n 0)
      (cons '() elts)
      (let ((left-size (quotient (- n 1) 2)))
	(let ((left-result (partial-tree elts left-size)))
	  (let ((left-tree (car left-result))
		(non-left-elts (cdr left-result))
		(right-size (- n (+ left-size 1))))
	    (let ((this-entry (car non-left-elts))
		  (right-result (partial-tree (cdr non-left-elts)
					      right-size)))
	      (let ((right-tree (car right-result))
		    (remaining-elts (cdr right-result)))
		(cons (make-tree this-entry left-tree right-tree)
		      remaining-elts))))))))

(define (union-set set1 set2)
  (cond ((null? set1) set2)
        ((null? set2) set1)
        (else
         (let ((e1 (car set1))
               (e2 (car set2)))
           (cond ((< e1 e2) (cons e1 (union-set (cdr set1) set2)))
                 ((= e1 e2) (cons e1 (union-set (cdr set1) (cdr set2))))
                 ((> e1 e2) (cons e2 (union-set set1 (cdr set2)))))))))

(define (intersection-set list1 list2)
  (if (or (null? list1) (null? list2))
      '()
      (let ((e1 (car list1))
	    (e2 (car list2)))
	(cond ((< e1 e2) (intersection-set (cdr list1) list2))
	      ((= e1 e2) (cons e1 (intersection-set (cdr list1) (cdr list2))))
	      ((> e1 e2) (intersection-set list1 (cdr list2)))))))

;; Answer
(define (union-tree tree1 tree2)
  (let ((list1 (tree->list-2 tree1))
	(list2 (tree->list-2 tree2)))
    (list->tree (union-set list1 list2))))

(define (intersection-tree tree1 tree2)
  (let ((list1 (tree->list-2 tree1))
	(list2 (tree->list-2 tree2)))
    (list->tree (intersection-set list1 list2))))
  


;; TEST
(define u-tree (union-tree (list->tree '(1 3 5 7 9))  (list->tree '(1 2 3 4 5))))
u-tree
(tree->list-2 u-tree)

(define i-tree (intersection-tree (list->tree '(1 3 5 7 9 11 13 15 17))  (list->tree '(1 2 3 4 5 6 7 8 9 10 11))))
i-tree
(tree->list-2 i-tree)



		
	   
