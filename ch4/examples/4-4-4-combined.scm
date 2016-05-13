(load "4-4-4-1")
(load "4-4-4-2")
(load "4-4-4-3")
(load "4-4-4-4")
(load "4-4-4-5")
(load "4-4-4-6")
(load "4-4-4-7")
(load "4-4-4-8")


(define sample "
;; the following is not in infinite loop

(assert! (say bye 1))
(assert! (say bye 2))
(assert! (say hello 1))
(assert! (say hello 2))
(assert! (rule (disp ?x ?y) (say ?y ?x)))
(assert! (rule (same ?x ?x)))
(and (say bye ?x)
     (not (same ?x 2)))
(and (say bye ?x) (say hello ?y) (same ?x ?y) (lisp-value > ?x 1))
(and (say bye ?x) (say hello ?y) (same ?x ?y) (not (lisp-value > ?x 1)))
(and (say bye ?x) (say hello ?y) (or (lisp-value > ?x 1) (same ?x ?y)))

")


(query-driver-loop)
