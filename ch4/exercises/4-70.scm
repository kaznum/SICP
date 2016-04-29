;; original in text
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
        (cons-stream assertion old-assertions)))
  'ok)



;; in ex6.70
(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (set! THE-ASSERTIONS
        (cons-stream assertion THE-ASSERTIONS))
  'ok)

;; The Answer
;;
;; (let ...) generates a new environment by the way of lambda,
((lambda (old-assertions)
   (set! THE-ASSERTIONS
         (cons-stream assertion old-assertions)))
 THE-ASSERTIONS)
;; , which delays the evaluation of THE-ASSERTIONS
;; until (cons-stream ...) has set up the promise.
;; On the other hand, without 'let', it generates the infinite stream of 'assertion'.


;; REPL examples

;; 1 ]=> (define a the-empty-stream)
;; ;Value: a
;; 1 ]=> (set! a (cons-stream 1 a))
;; ;Value: ()
;; 1 ]=> (set! a (cons-stream 2 a))
;; ;Value 10: (1 . #[promise 11])
;; 1 ]=> (stream-ref a 0)
;; ;Value: 2
;; 1 ]=> (stream-ref a 1)
;; ;Value: 2            ;; This wants to be 1
;; 1 ]=> (stream-ref a 3)
;; ;Value: 2            ;; This wants to be error.


;; 1 ]=> (define a the-empty-stream)
;; ;Value: a
;; 1 ]=> (let ((b a)) (set! a (cons-stream 1 b)))
;; ;Value: ()
;; 1 ]=> (let ((b a)) (set! a (cons-stream 2 b)))
;; ;Value 16: (1 . #[promise 17])
;; 1 ]=> (stream-ref a 0)
;; ;Value: 2
;; 1 ]=> (stream-ref a 1)
;; ;Value: 1
;; 1 ]=> (stream-ref a 3)
;; ;error
