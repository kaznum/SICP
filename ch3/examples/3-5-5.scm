;; (define rand
;;   (let ((x random-init))
;;     (lambda ()
;;       (set! x (rand-update x))
;;       x)))

(define random-init 1)
(define (rand-update i) (remainder (* i 3) 17))

(define random-numbers
  (cons-stream
   random-init
   (stream-map rand-update random-numbers)))

(define (map-successive-pairs f s)
  (cons-stream
   (f (stream-car s) (stream-car (stream-cdr s)))
   (map-successive-pairs f (stream-cdr (stream-cdr s)))))

(define cesaro-stream
  (map-successive-pairs
   (lambda (r1 r2) (= (gcd r1 r2) 1))
   random-numbers))

(define (monte-carlo experiment-stream passed failed)
  (define (next passed failed)
    (cons-stream
     (/ passed (+ passed failed))
     (monte-carlo
      (stream-cdr experiment-stream) passed failed)))
  (if (stream-car experiment-stream)
      (next (+ passed 1) failed)
      (next passed (+ failed 1))))
(define pi
  (stream-map
   (lambda (p) (sqrt (/ 6 p)))
   (monte-carlo cesaro-stream 0 0)))


(stream-ref pi 1000)
(stream-ref pi 100000)

;;; A functional-programming view of time
(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount))
    balance))

(define simple-withdraw (make-simplified-withdraw 1000))
(simple-withdraw 200)
;; 800
(simple-withdraw 300)
;; 500

(define (stream-withdraw balance amount-stream)
  (cons-stream
   balance
   (stream-withdraw (- balance (stream-car amount-stream))
		    (stream-cdr amount-stream))))

(define amounts
  (cons-stream 200
	       (stream-map (lambda (x) (+ 100 x)) amounts)))

(define balances (stream-withdraw 1000 amounts))
(stream-ref balances 0)
;; 1000
(stream-ref balances 1)
;; 800
(stream-ref balances 2)
;; 500
