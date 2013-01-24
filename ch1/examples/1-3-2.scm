;;
;; Constructing Procedures Using `lambda'
;;
((lambda (x) (+ x 4)) 4)

((lambda (x) (/ 1.0 (* x (+ x 2)))) 2)

(define (pi-sum a b)
  (sum (lambda (x) (/ 1.0 (* x (+ x 2))))
       a
       (lambda (x) (+ x 4))
       b))


(define (integral f a b dx)
  (* (sum f
	  (+ a (/ dx 2.0))
	  (lambda (x) (+ x dx))
	  b)
     dx))

(define (plus4 x) (+ x 4))
(plus4 3)

(define plus4-l (lambda (x) (+ x 4)))
(plus4-l 3)

((lambda (x y z) (+ x y (square z))) 1 2 3)
;; 12

;;
;; Using `let' to create local variables
;;

;; to be continued

