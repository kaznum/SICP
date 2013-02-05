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


