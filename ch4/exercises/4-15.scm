(define (run-forever) (run-forever))
(define (try p)
  (if (halts? p p) (run-forever) 'halted))

;; evaluating (try try)

;; (halts? p p) -> (halts? try try)
;; If (halts? try try)) is true (which means 'halt'), but (run-forever) is executed.
;; If false (which means 'not halt'), but returns 'halts.
;; This is a paradox.
