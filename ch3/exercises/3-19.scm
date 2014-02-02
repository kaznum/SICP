;;; There are two pointers, and the one traverses by double speed of the other
;;; If there is a loop, sometime, they meet each other.
;;; But this model ignores when there is a loop in the 'car' element.

(define (cycle? exp)
  (define (same? singlestep-ptr doublestep-ptr)
    (cond ((null? singlestep-ptr) false)
	  ((null? doublestep-ptr) false)
	  ((null? (cdr doublestep-ptr)) false)
	  ((eq? singlestep-ptr doublestep-ptr) true)
	  ((eq? singlestep-ptr (cdr doublestep-ptr)) true)
	  (else
	   (same? (cdr singlestep-ptr) (cddr doublestep-ptr)))))
  (same? exp (cdr exp)))


;;; TEST

(cycle? '(a b c d))
;Value: #f

;;; loop in cdr
(define p1 '(x y z))
(cycle? (list 'a p1 p1))
;Value: #f
(set-cdr! (cddr p1) p1)
(cycle? p1)
;Value: #t

;;; loop in car
(define p2 '(x y z))
(cycle? p2)
;Value: #f
(set-car! (cdr p2) p2)
(cycle? p2)
;Value: #f (Ignore 'car' elements)


;; This becomes infinite loop
;; When the elements (not the first element) is refered by the end of the list
(define x (list 'a 'b))
(set-cdr! (cdr x) (cdr x))
(cycle? x)
