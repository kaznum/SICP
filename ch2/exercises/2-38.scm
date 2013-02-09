;; Given
(define (fold-right op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (fold-right op initial (cdr sequence)))))

(define (fold-left op initial sequence)
  (define (iter result rest)
    (if (null? rest)
	result
	(iter (op result (car rest))
	      (cdr rest))))
  (iter initial sequence))


(fold-right / 1 (list 1 2 3))
;;=> (/ 1 (/ 2 (/ 3 1)))
;;=> (/ 1 (/ 2 3))
;;=> 3/2

(fold-left / 1 (list 1 2 3))
;;=> (iter 1 (list 1 2 3))
;;=> (iter (/ 1 1) (list 2 3))
;;=> (iter (/ (/ 1 1) 2) (list 3))
;;=> (iter (/ (/ (/ 1 1) 2) 3) '())
;;=> (/ (/ (/ 1 1) 2) 3)
;;=> (/ (/ 1 2) 3)
;;=> 1/6

(fold-right list '() (list 1 2 3))
;; (list 1 (fold-right list '() (list 2 3)))
;; (list 1 (list 2 (fold-right list '() (list 3))))
;; (list 1 (list 2 (list 3 (fold-right list '() '()))))
;; (list 1 (list 2 (list 3 '())))
;; '(1 (2 (3 ())))

(fold-left list '() (list 1 2 3))
;; (iter '() '(1 2 3))
;; (iter '(() 1) '(2 3))
;; (iter '((() 1) 2) '(3))
;; (iter '(((() 1) 2) 3) '())
;; '(((() 1) 2) 3)

;; When fold-right's and fold-left's results are same, the operator satisfies the following.
;; The results of both (op a b) and (op b a) are equal

(fold-right + 0 (list 1 2 3))
(fold-left + 0 (list 1 2 3))

(fold-right * 1 (list 2 3 4))
(fold-left * 1 (list 2 3 4))
