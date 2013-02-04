;; Answer (1)
(define (square-list items)
  (if (null? items)
      '()
      (cons (square (car items)) (square-list (cdr items)))))

;; TEST
(square-list (list 1 2 3 4))

;; Answer (2)
(define (square-list items)
  (map square items))

;; TEST
(square-list (list 1 2 3 4))
