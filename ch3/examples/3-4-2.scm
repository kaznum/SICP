;; Serializing access to shared state

;; Serializers in Scheme
;; (define x 10)
;; (parallel-execute
;;  (lambda () (set! x (* x x)))
;;  (lambda () (set! x (+ x 1))))

(define x 10)
(define s (make-serializer))
(parallel-execute
 (s (lambda () (set! x (* x x))))
 (s (lambda () (set! x (+ x 1))))

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((protected (make-serializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) (protected withdraw))
	    ((eq? m 'deposit) (protected deposit))
	    ((eq? m 'balance) balance)
	    (else (error "Unknown request -- MAKE-ACCOUNT"
			 m))))
    dispatch))

;; Complexity of using multiple shared resources
(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
		       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))


;; to be continued
