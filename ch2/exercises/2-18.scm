;; iterative process
(define (reverse l)
  (define (iter l result)
    (if (null? l)
	result
	(iter (cdr l) (cons (car l) result))))
  (iter l (list)))

(reverse (list 1 4 9 16 25))
(reverse (list 1))
(reverse '())

;; recursive process
(define (reverse l)
  (define nil '())
  (if (< (length l) 2)
      l
      (append (reverse (cdr l)) (cons (car l) nil))))


(reverse (list 1 4 9 16 25))
(reverse (list 1))
(reverse '())
