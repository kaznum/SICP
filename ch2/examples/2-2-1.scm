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

(define (list-ref items n)
  (if (= n 0)
      (car items)
      (list-ref (cdr items) (- n 1))))

(define squares (list 1 4 9 16 25))

(list-ref squares 3)

;; recursive length
(define (length items)
  (if (null? items)
      0
      (+ 1 (length (cdr items)))))

(define odds (list 1 3 5 7))
(length odds)

;; iterative length
(define (length items)
  (define (length-iter a count)
    (if (null? a)
	count
	(length-iter (cdr a) (+ 1 count))))
  (length-iter items 0))

(define odds (list 1 3 5 7))
(length odds)

(define (append list1 list2)
  (if (null? list1)
      list2
      (cons (car list1) (append (cdr list1) list2))))

