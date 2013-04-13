(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (let ((incorrect-password-count 0))
    (define (dispatch p m)
      (if (eq? p password)
	  (begin (set! incorrect-password-count 0)
		 (cond ((eq? m 'withdraw) withdraw)
		       ((eq? m 'deposit) deposit)
		       (else (error "Unknown request -- MAKE-ACCOUNT"
				    m))))
	  (begin (set! incorrect-password-count (+ incorrect-password-count 1))
		 (if (>= incorrect-password-count max-errors)
		     (lambda (amount) (call-the-cops))
		     (lambda (amount) (error "Incorrect password"))))))
    dispatch))

(define max-errors 7)
(define (call-the-cops) (error "POLICE POLICE POLICE"))

(define acc (make-account 100 'secret-password))
((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'deposit) 50)
((acc 'secret-password 'withdraw) 40)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
((acc 'some-other-password 'deposit) 50)
;; "POLICE POLICE POLICE"

