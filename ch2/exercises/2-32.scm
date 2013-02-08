(define (subsets s)
  (if (null? s)
      (list '())
      (let ((rest (subsets (cdr s))))
	(append rest (map (lambda (x) (cons (car s) x)) rest)))))

(subsets (list 1 2 3))


;; 'rest' is the all collection of the numbers except the first number
;; And (map ...) prepends the first number to all of the element in the rest.
