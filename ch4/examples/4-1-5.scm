(define (factorial n)
  (if (= n 1) 1 (* (factorial (- n 1)) n)))


(eval '(* 5 5) user-initial-environment)
;; 25

(eval (cons '* (list 5 5)) user-initial-environment)
;; 25
