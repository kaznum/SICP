;; Given
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

;; a)
;;
;; partial-tree separate left-tree top(this-entry) right-tree
;; and create left-tree and right-tree recursively.
;; At first, partial-tree creates left-tree and node element
;; is given from the top of the elements which left-tree remains,
;; and then create right-tree with the other elements

;; 
;; (1 3 5 7 9 11)
;;     5
;; 1       9
;;   3   7   11

;; b)
;; [theta](n) because partial-tree accesses the every elements
;; in a process recursively
