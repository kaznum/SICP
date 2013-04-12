(define (make-accumulator total)
  (lambda (value)
    (begin
      (set! total (+ total value))
      total)))

;; TEST
(define A (make-accumulator 5))
(A 10)
(A 10)




