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

;; using define
(define (f x y)
  (define (f-helper a b)
    (+ (* x (square a))
       (* y b)
       (* a b)))
  (f-helper (+ 1 (* x y))
	    (- 1 y)))

;; using lambda
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a))
	(* y b)
	(* a b)))
   (+ 1 (* x y))
   (- 1 y)))

;; using let
(define (f x y)
  (let ((a (+ 1 (* x y)))
	(b (-1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))

(let ((x 5))
  (+ (let ((x 3))
       (+ x (* x 10)))
     x))

(let ((x 2))
  (let ((x 3)
	(y (+ x 2)))
    (* x y)))

;; internal definitions (not prefered)
(define (f x y)
  (define a (+ 1 (* x y)))
  (define b (- 1 y))
  (+ (* x (square a))
     (* y b)
     (* a b)))
(f 2 3)
