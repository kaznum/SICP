(define (run-forever) (run-forever))
(define (try p)
  (if (halts? p p) (run-forever) 'halted))

;; evaluating (try try)

;; (halts? p p) -> (halts? try try)
;; If (halts? try try) is true, (run-forever) is executed,
;; which means the procedure does not halt.
;; If not, 'halts.
;; It is paradox.
