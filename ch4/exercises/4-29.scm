;; The Fibonacci number is the good example.

(define (fib n)
  (cond ((= n 0) 1)
	((= n 1) 1)
	(else (+ (fib (- n 2)) (fib (- n 1))))))
;; see the result of implementation with/without memoize in
;; 4-29-with-memoize.scm and 4-29-without-memoize.scm

(define count 0)
(define (id x) (set! count (+ count 1)) x)
(define (square x) (* x x))

;; without memoization
(square (id 10))
;; -> (square (thunk (id 10)))
;; -> (* (thunk (id 10))) (thunk (id 10)))
;; -> (* 10 (thunk (id 10))) ;; where count = 1
;; -> (* 10 10) ;; where count = 2
;; -> 100 ;; where count = 2
;; Then
;; square's response: 100
;; count's response: 2

;; with memoization
(square (id 10))
;; -> (square (thunk (id 10)))
;; -> (* t t) ;; where t = (thunk (id 10))) which is memoize
;; -> (* 10 t) ;; where count = 1 and t = (evaluated-thunk 10)
;; -> (* 10 10) ;; where count = 1
;; -> 100
;; Then
;; square's response: 100
;; count's response: 1
