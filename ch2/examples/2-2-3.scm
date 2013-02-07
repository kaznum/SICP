(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
	((not (pair? tree))
	 (if (odd? tree) (square tree) 0))
	(else (+ (sum-odd-squares (car tree))
		 (sum-odd-squares (cdr tree))))))

(define (even-fibs n)
  (define (next k)
    (if (> k n)
	 '()
	 (let ((f (fib k)))
	   (if (even? f)
	       (cons f (next (+ k 1)))
	       (next (+ k 1))))))
  (next 0))

;; Sequence Operations

;; to be continued
