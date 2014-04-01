;; Answer a.

((lambda (n)
   ((lambda (fact) (fact fact n))
    (lambda (ft k)
      (if (= k 1)
	  1
	  (* k (ft ft (- k 1)))))))
 10)

;;=> apply arg n := 10

((lambda (fact) (fact fact 10))
 (lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1))))))

;; => extract
((lambda (ft k)
   (if (= k 1)
       1
       (* k (ft ft (- k 1)))))
 fact 10)


;; => k in the first lambda = 10, then
;;  (* 10 (fact fact 9))
;; => (* 10 (* 9 (fact fact 8)))
;; => (* 10 (* 9 (* 8 (* fact fact 7))))
;; => ... => (* 10 (* 9 (* 8 ... (* 2 1)))...)

;; Answer b.

(define (f x)
  ((lambda (even? odd?) (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))))

;; TEST
(f 10)
;; #t
(f 9)
;; #f
(f 8)
;; #t
(f 1)
;; #f

;; The first of <??> corresponds to 'even?'
;; The second one does to 'odd?'
;; The last one is the deduction for recursion




