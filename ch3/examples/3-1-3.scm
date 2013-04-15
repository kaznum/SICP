(define (make-simplified-withdraw balance)
  (lambda (amount)
    (set! balance (- balance amount))
    balance))

(define W (make-simplified-withdraw 25))

(W 20)
(W 10)

;; use no assignment
(define (make-decrementer balance)
  (lambda (amount)
    (- balance amount)))

(define D (make-decrementer 25))

(D 20)

(D 10)

((make-decrementer 25) 20)
((make-simplified-withdraw 25) 20)

;; Sameness and change

;; D1 and D2 have the same behavior
(define D1 (make-decrementer 25))
(define D2 (make-decrementer 25))

;; W1 and W2 are not same
(define W1 (make-simplified-withdraw 25))
(define W2 (make-simplified-withdraw 25))

(W1 20)
(W1 20)

(W2 20)

;; distinct
(define peter-acc (make-account 100))
(define paul-acc (make-account 100))

;; shared account
(define peter-acc (make-account 100))
(define paul-acc peter-acc)

;; Pitfalls of Imperative programming

;; to be continued
