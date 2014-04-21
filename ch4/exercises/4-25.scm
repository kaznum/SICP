(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

(define (factorial n)
  (unless (= n 1)
	  (* n (factorial (- n 1)))
	  1))

(factorial 5)
;;=>
(unless (= 5 1)
	(* 5 (factorial (- 5 1))) 1)
;;=>
(unless false
	(* 5 (factorial 4)) 1)

;;=>
(unless false
	(* 5 (unless false
		     (* 4 (factorial 3)) 1)) 1)
;;=>
(unless false
	(* 5 (unless false
		     (* 4 (unless false
				  (* 3 (factorial 2))
				  1)) 1)) 1)
;;=>
(unless false
	(* 5 (unless false
		     (* 4 (unless false
				  (* 3 (unless false
					       (* 2 (factorial 1))
					       1)) 1)) 1)) 1)
;;=>
(unless false
	(* 5 (unless false
		     (* 4 (unless false
				  (* 3 (unless false
					       (* 2 (unless true
							    (* 1 (factorial 0))
							    1)) 1)) 1)) 1)) 1)
;;=>
(unless false
	(* 5 (unless false
		     (* 4 (unless false
				  (* 3 (unless false
					       (* 2 (unless true
							    (* 1 (unless false
									 (* 0 (factorial -1))
									 1)) 1)) 1)) 1)) 1)) 1)
;;=> it will not end forever

;; when it is in normal order language,
(unless (= n 1)
	(* n (factorial (- n 1))) 1)
=>
(if (= n 1)
    1
    (* n (factorial (- n 1))))
;; where n = 5
=>
;; (= n 1) is evaluated first where n = 5, then
(* n (factorial (- n 1)))
;; where n = 5
=>
(* n (if (= (- n 1) 1)
	 1
	 (* (- n 1) (factorial (- (- n 1) 1)))))
;; where n = 5.
;; first, second n  and (= (- n 1) 1) is evaluated first, then
(* 5 (* 4 (factorial (- (- (- n 1) 1) 1))))
(* 5 (* 4 (* 3 (* 2 (* 1 1)))))
;; => 120





	   
