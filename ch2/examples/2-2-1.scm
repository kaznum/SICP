(cons 1 (cons 2 (cons 3 (cons 4 nil))))

(list 1 2 3 4)

(define one-through-four (list 1 2 3 4))
one-through-four

(car one-through-four)
(cdr one-through-four)
(car (cdr one-through-four)) ;; 2
(cdr (cdr one-through-four)) ;; (3 4)
(cdr (cdr (cdr one-through-four)))  ;; (4)

(car (cdr (cdr (cdr one-through-four)))) ;; 4
(cdr (cdr (cdr (cdr one-through-four)))) ;; ()

(cdr (cdr (cdr (cdr (cdr one-through-four))))) ;; error
(car (cdr (cdr (cdr (cdr one-through-four))))) ;; error

(cons 10 one-through-four)
(cons 5 one-through-four)

;;
;; List Operations
;;

;; to be continued
