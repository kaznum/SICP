(define (equal? a b)
  (cond ((and (null? a) (null? b)) true)
	((or (null? a) (null? b)) false)
	(else
	 (let ((car_a (car a))
	       (car_b (car b)))
	   (if (and (pair? car_a) (pair? car_b))
	       (and (equal? car_a car_b) (equal? (cdr a) (cdr b)))
	       (and (eq? car_a car_b) (equal? (cdr a) (cdr b))))))))

(define (equal? a b)
  (cond ((and (pair? a) (pair? b))
	 (and (equal? (car a) (car b)) (equal? (cdr a) (cdr b))))
	((and (not (pair? a)) (not (pair? b)))
	 (and (eq? a b)))
	(else false)))


;; TEST
(equal? '(this is a list) '(this is a list))
(equal? '(this is a list) '(this (is a) list))
(equal? '(this (is a) list) '(this (is a) list))
(equal? '(this (is (a)) list) '(this (is (a)) list))
(equal? '(this (is a) lists) '(this (is a) list))
(equal? '(this (is a) list) '(this (is a) list of symbols))
(equal? '(this (is a) list of symbols) '(this (is a) list))

