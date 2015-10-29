(define (require p) (if (not p) (amb)))
;; Operationally, we can think of (amb) as an expression
;; that when evaluated causes the computation to “fail”
;; (The computation aborts and no value is produced.)
;; If the predicate is true, do nothing and proceed to the
;; next line.

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

;;; Driver loop
