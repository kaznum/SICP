;; Given in this exercise
(define (make-account balance)
  (define (withdraw amount)
    (if (>= blaance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit) deposit)
	  (else (error "Unknown request -- MAKE-ACCOUNT"
		       m))))
  dispatch)


;; After definition of make-account
           +--------------------------------------------------+
 global -->| make-account:                                    |
 env       |         |                                        |
           +---------|----------------------------------------+
                     V       ^
                 .---.---.   |
      +----------+-O | O-+---+
      |          `---^---'
      V
 parameters: balance
 body: (define withdraw ...)
       (define deposit ...)
       (define dispatch ...)
       dispatch


;; Next, after 'acc' is defined,
(define acc (make-account 50))

           +---------------------------------------------------------------+
 global -->| make-account:                                                 |
 env       | acc: ---|------------------+                                  |
           +---------|------------------|----------------------------------+
                     V       ^          V        	                 ^
                 .---.---.   |      .---.---.    	                 |
      +----------+-O | O-+---+    +-+-O | O-+---+ 	      +----------+------------------+
      |          `---^---'        | `---^---'   |  	E1 -> | balance: 50                 |
      V                           V             |             | withdraw: -----+            |
 parameters: balance           parameters: m	+------------>| deposit: ...   |            |
 body: (define withdraw ...)   (cond ((eq? m 'withdraw ...    | dispatch: ...  |            |
       (define deposit ...)      ....  		  	      +----------------|------------+
       (define dispatch ...)      		  	                       |         ^
       dispatch                   		  	                       V         |
				  		  			       .---.---. |
				  		  			       | O | O-+-+
						  			       `-|-^---'
                                        	  		                 |
                                        	  		                 V
                                        	  		              parameter: amount
                                        	  		              body: (if (>= blaance amount)
				 		  				      	(begin (set! balance (- balance amount))
				 		  				      	       balance)
				 		  				      	"Insufficient funds"))

;; Next, after deposit 40
((acc 'deposit) 40)

