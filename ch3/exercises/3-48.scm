;;;
;;; The original case (deadlock happens)
;;;
;;                           a1(s1)    a2(s2)
;; P1: (exchange a1 a2)                          P2: (exchange a2 a1)
;;         |                                              |
;;         V                                              |
;;     lock of s2-------------------> locked              |
;;         |                            |                 V
;;         |                locked <----|-------------lock of s1
;;         V                   |        |                 |
;;     lock of s1(wait)------->|        |                 |
;;                             |        |                 V
;;                             |        |<----------- lock of s2(wait)

;;;
;;; weighed by id of account (deadlock avoided)
;;;
;;                           a1(s1)    a2(s2)
;; P1: (exchange a1 a2)                          P2: (exchange a2 a1)
;;         |                                              |
;;         V                                              |
;;     lock of s1---------> locked                        |
;;         |                   |                          V
;;         |                   |<------------------- lock of s1(wait)
;;         V                   |                          |
;;     lock of s2--------------|-----> locked             |
;;         |                   |          |               |
;;         V                   |          V               |
;;     release s2--------------|-----> released           |
;;         |                   |                          |
;;         V                   V                          |
;;     release s1---------> released                      |
;;                                                        V
;;                           locked <------------------ lock of s1
;;                             |                          |
;;                             |                          V
;;                             |         locked <------ lock of s2
;;                             |            |             |
;;                             |            V             V
;;                             |         released <---- release of s2
;;                             |                          |
;;                             V                          V
;;                           released <---------------- release of s1



;; exchange has no change
(define (exchange account1 account2)
  (let ((difference (- (account1 'balance)
		       (account2 'balance))))
    ((account1 'withdraw) difference)
    ((account2 'deposit) difference)))

;; the calling order of serializered depends on the id of accounts
;; of arguments
(define (serialized-exchange account1 account2)
  (let ((serializer1 (account1 'serializer))
	(serializer2 (account2 'serializer))
	(number1 (account1 'number))
	(number2 (account2 'number)))
    (if (number1 < number2)
	((serializer2 (serializer1 exchange)) account1 account2)
	((serializer1 (serializer2 exchange)) account1 account2))))

(define (make-account balance n)
  (define (withdraw amount) ..)
  (define (deposit amount) ..)
  (let ((balance-serializer (make-srializer)))
    (define (dispatch m)
      (cond ((eq? m 'withdraw) withdraw)
	    ((eq? m 'deposit) deposit)
	    ((eq? m 'balance) balance)
	    ((eq? m 'serializer) balance-serializer)
	    ((eq? m 'number) n) ;; added
	    (else (error "..." m))))
    dispatch))
