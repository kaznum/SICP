(define x (cons-stream 'x 'y))

(stream-car x)
;; x
(stream-cdr x)
;; y

stream-ref
stream-map
stream-for-each

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x) (newline) (display x))

(define y (cons 'x (delay 'y)))
(car y)
;; x
(cdr y)
;; #[promise 7]
(stream-car y)
;; x
(stream-cdr y)
;; y
(force (cdr y))
;; y

;;; The stream implementation in action

;;;;;;; definition of prime? from ch1
(define (smallest-divisor n)
  (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

(define (prime? n)
  (= n (smallest-divisor n)))
;;;;;;;; end of the definition of prime?


(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(stream-car
 (stream-cdr
  (stream-filter prime?
		 (stream-enumerate-interval
		  10000 1000000))))


;; (define (stream-filter pred stream)
;;   (cond ((stream-null? stream) the-empty-stream)
;; 	((pred (stream-car stream))
;; 	 (cons-stream (stream-car stream)
;; 		      (stream-filter
;; 		       pred
;; 		       (stream-cdr stream))))
;; 	(else (stream-filter pred (stream-cdr stream)))))


;;; Implementing delay and force
;; (define (force delayed-object) (delayed-object))
;; (define (memo-proc proc)
;;   (let ((already-run? false)
;; 	(result false))
;;     (lambda ()
;;       (if (not already-run?)
;; 	  (begin (set! result (proc))
;; 		 (set! already-run? true)
;; 		 result)
;; 	  result))))
