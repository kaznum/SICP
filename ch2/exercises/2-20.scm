(define (same-parity a . b)
  (define (parity-of f? a)
    (if (null? a)
	'()
	(if (f? (car a))
	    (cons (car a) (parity-of f? (cdr a)))
	    (parity-of f? (cdr a)))))
  (cons a (parity-of (if (even? a) even? odd?) b)))


;; TEST
(same-parity 1 2 3 4 5 6 7)
;; (1 3 5 7)

(same-parity 2 3 4 5 6 7)
;; (2 4 6)

