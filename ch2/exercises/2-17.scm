(define (last-pair l)
  (if (> 2 (length l))
      l
      (last-pair (cdr l))))

;; TEST
(last-pair (list 23 72 149 34))
(last-pair (list 5))
(last-pair (list))

