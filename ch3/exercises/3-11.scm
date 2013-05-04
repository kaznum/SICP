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

           +---------------------------------------------------------------+
 global -->| make-account:                                                 |
 env       | acc: ---|------------------+                                  |
           +---------|------------------|----------------------------------+
                     V       ^          V        	                 ^
                 .---.---.   |      .---.---.    	                 |
      +----------+-O | O-+---+    +-+-O | O-+---+ 	      +----------+------------------+
      |          `---^---'        | `---^---'   |  	E1 -> | balance: 90                 |
      V                           V             |             | withdraw: -----+            |
 parameters: balance           parameters: m	+------------>| deposit: ...   |            |
 body: (define withdraw ...)   (cond ((eq? m 'withdraw ...    | dispatch: ...  |            |
       (define deposit ...)      ....  		  	      +----------------|------------+
       (define dispatch ...)      		  	        ^  ^           |     ^
       dispatch                   		  	        |  |           V     |
				  		  	        |  |       .---.---. |
				  		  	        |  |       | O | O-+-+
						  	        |  |       `-|-^---'
                                        	  		|  |         |
                                        	  		|  |         V
                                          +---------------------+  |      parameter: amount
                                          |  	                   |      body: (if (>= blaance amount)
				 	  |  	                   |            (begin (set! balance (- balance amount))
				 	  |  	                   |                   balance)
				 	  |                        |             "Insufficient funds"))
                                          |                        |
                                 +--------+-----+           +------+------+
                           E2 -> | m: 'dispatch |     E3 -> | amount: 40  |
                                 +--------------+           +-------------+
                                call to dispatch           call to deposit


;; Next, after deposit 60
((acc 'withdraw) 60)

E2 and E3 have disappeared

           +---------------------------------------------------------------+
 global -->| make-account:                                                 |
 env       | acc: ---|------------------+                                  |
           +---------|------------------|----------------------------------+
                     V       ^          V        	                 ^
                 .---.---.   |      .---.---.    	                 |
      +----------+-O | O-+---+    +-+-O | O-+---+ 	      +----------+------------------+
      |          `---^---'        | `---^---'   |  	E1 -> | balance: 30                 |
      V                           V             |             | withdraw: -----+            |
 parameters: balance           parameters: m	+------------>| deposit: ...   |            |
 body: (define withdraw ...)   (cond ((eq? m 'withdraw ...    | dispatch: ...  |            |
       (define deposit ...)      ....  		  	      +----------------|------------+
       (define dispatch ...)      		  	        ^  ^           |     ^
       dispatch                   		  	        |  |           V     |
				  		  	        |  |       .---.---. |
				  		  	        |  |       | O | O-+-+
						  	        |  |       `-|-^---'
                                        	  		|  |         |
                                        	  		|  |         V
                                          +---------------------+  |      parameter: amount
                                          |  	                   |      body: (if (>= blaance amount)
				 	  |  	                   |            (begin (set! balance (- balance amount))
				 	  |  	                   |                   balance)
				 	  |                        |             "Insufficient funds"))
                                          |                        |
                                 +--------+-----+           +------+------+
                           E4 -> | m: 'dispatch |     E5 -> | amount: 60  |
                                 +--------------+           +-------------+
                                call to dispatch           call to withdraw

;; Next, defined acc2
(define acc2 (make-account 100))

           +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
 global -->| make-account:                                                                                                                                                                |
 env       | acc: ---|------------------+                                                                                                                                                 |
           | acc2: --|------------------|--------------------------------------------------------------------------------------------+                                                    |
           +---------|------------------|--------------------------------------------------------------------------------------------|----------------------------------------------------+
                     V       ^          V        	                 ^                                                           V                                ^
                 .---.---.   |      .---.---.    	                 |						         .---.---.                            |
      +----------+-O | O-+---+    +-+-O | O-+---+ 	      +----------+------------------+                                  +-+-O | O-+---+             +----------+------------------+
      |          `---^---'        | `---^---'   |  	E1 -> | balance: 30                 |				       | `---^---'   |       E2 -> | balance: 100                |
      V                           V             |             | withdraw: -----+            |				       V             |             | withdraw: -----+            |
 parameters: balance           parameters: m	+------------>| deposit: ...   |            |				    parameters: m    +------------>| deposit: ...   |            |
 body: (define withdraw ...)   (cond ((eq? m 'withdraw ...    | dispatch: ...  |            |				    (cond ((eq? m 'withdraw ...    | dispatch: ...  |            |
       (define deposit ...)      ....  		  	      +----------------|------------+				      ....                         +----------------|------------+
       (define dispatch ...)      				               |     ^					                                                    |     ^
       dispatch                   					       V     |					                                                    V     |
				  					   .---.---. |					                                                .---.---. |
				  					   | O | O-+-+					                                                | O | O-+-+
									   `-|-^---'					                                                `-|-^---'
                                        				     |						                                                  |
                                        				     V						                                                  V
                                        				  parameter: amount				                                               parameter: amount
                                        				  body: (if (>= blaance amount)			                                               body: (if (>= blaance amount)
				 					        (begin (set! balance (- balance amount))                                                     (begin (set! balance (- balance amount))
				 					               balance)				                                                            balance)
				 					         "Insufficient funds"))			                                                      "Insufficient funds"))


;; acc and acc2 share only the global env and the body of MAKE-ACCOUNT.

