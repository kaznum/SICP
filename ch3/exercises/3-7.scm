;; From ex3-3
;; There is no change.
(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch p m)
    (cond ((not (eq? p password)) (lambda (x) (error "Incorrect password")))
	  ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit) deposit)
	  (else (error "Unknown request -- MAKE-ACCOUNT"
		       m))))
  dispatch)

;; The answer of this ex.
(define (make-joint account password new-password)
  (define (dispatch p m)
    (if (eq? p new-password)
	(account password m)
	(lambda (x) (error "Incorrect password"))))
  dispatch)

;; TEST
(define peter-acc (make-account 100 'open-sesame))
(define paul-acc
  (make-joint peter-acc 'open-sesame 'rosebud))

((peter-acc 'open-sesame 'withdraw) 30)
;; 70
((paul-acc 'open-sesame 'withdraw) 30)
;; Incorrect password
((paul-acc 'rosebud 'withdraw) 30)
;; 40
((paul-acc 'rosebud 'deposit) 90)
;; 130
((peter-acc 'open-sesame 'deposit) 10)
;; 140

