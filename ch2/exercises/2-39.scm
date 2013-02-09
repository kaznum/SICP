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

;; Answer for fold-right
(define (reverse sequence)
  (fold-right (lambda (x y) (append y (list x))) '() sequence))

;; TEST
(reverse '(1 2 3 4 5))

;; Answer for fold-left
(define (reverse sequence)
  (fold-left (lambda (x y) (cons y x)) '() sequence))

;; TEST
(reverse '(1 2 3 4 5))
