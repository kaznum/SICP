;; a.
(and (supervisor ?person (Bitdiddle Ben))
     (address ?person ?where))

;; b.
(and (salary (Bitdiddle Ben) ?ben-saraly)
     (salary ?person ?amount)
     (lisp-value < ?amount ?ben-saraly))

;; c.
(and (supervisor ?person ?supervisor)
     (not (job ?supervisor (computer . ?subdivision)))
     (job ?supervisor ?division))
