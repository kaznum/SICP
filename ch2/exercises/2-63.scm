;; a)

;; Given
(define (tree->list-1 tree)
  (if (null? tree)
      '()
      (append (tree->list-1 (left-branch tree))
	      (cons (entry tree)
		    (tree->list-1 (right-branch tree))))))

(define (tree->list-2 tree)
  (define (copy-to-list tree result-list)
    (if (null? tree)
	result-list
	(copy-to-list (left-branch tree)
		      (cons (entry tree)
			    (copy-to-list (right-branch tree)
					  result-list)))))
  (copy-to-list tree '()))


;; There is no difference between the results of both of
;; the procedures

;; Figure2.16's results
;; (1 3 5 7 9 11)
;; (1 3 5 7 9 11)
;; (1 3 5 7 9 11)

;; TEST
(define tree1 (list 7 (list 3 (list 1 '() '()) (list 5 '() '())) (list 9 '() (list 11 '() '()))))
(tree->list-1 tree1)
(tree->list-2 tree1)

(define tree2 (list 3 (list 1 '() '()) (list 7 (list 5 '() '()) (list 9 '() (list 11 '() '())))))
(tree->list-1 tree2)
(tree->list-2 tree2)

(define tree3 (list 5 (list 3 (list 1 '() '()) '()) (list 9 (list 7 '() '()) (list 11 '() '()))))
(tree->list-1 tree3)
(tree->list-2 tree3)


;; b)
;; tree->list-1 is called recursively ,in which the same order of growth is O(n)
;; but in each tree->list-1, 'append' access the items in each level O(log(n))
;; So, the answer is O(n*log(n))


;; Why log(n)?
;; If the tree is in balance, a node has the elements 0 2 6 14 30 ... x_n-1  x_n (from the bottom).
;; x_n = 2*(x_n-1 + 1)
;; All the summation of this (which is the number of all the elements) from n = 0 to k
;; is proportional to 2^k.
;;
;; So at a 'k', the elements below this is proportional log(n)
;; (where n is the number of all of the elements)


