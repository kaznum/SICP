(define (ident-pairs exp pairs)
  (if (or (not (pair? exp)) (any (lambda (x) (eq? exp x)) pairs))
      pairs
      (let ((new-pairs (cons exp pairs)))
	(ident-pairs (car exp) (ident-pairs (cdr exp) new-pairs)))))

(define (count-pairs x)
  (length (ident-pairs x '())))


;; There are three pairs and the previous function returns 3
(count-pairs '(x y z))
;Value: 3

;; There are three pairs but the previous function returns 4
(define p1 (cons 'a 'b))
(count-pairs (cons (cons p1 p1) '()))
;Value: 3

;; There are three pairs but the previous function returns 5
(define p2 '(a))
(count-pairs (cons (cons p2 p2) p2))
;Value: 3

;; There are three pairs but the previous function returns 4
(define p2 '(a))
(count-pairs (cons (cons 'x p2) p2))
;Value: 3

