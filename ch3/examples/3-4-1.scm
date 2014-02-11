(define (withdraw amount)
  (if (>= balance amount)
      (begin
	(set! balance (- balance amount))
	balance)
      "Insufficient funds"))

;;; Correct behavior of concurrent programs

;; to be continued

