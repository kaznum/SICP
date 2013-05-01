;; Given in this exercise
(define (make-withdraw initial-amount)
  (let ((balance initial-amount))
    (lambda (amount)
      (if (>= balance amount)
	  (begin (set! balance (- balance amount))
		 balance)
	  "Insufficient funds"))))

;; This is interpreted as follows,
(define (make-withdraw initial-amount)
  (lambda (balance)
    (lambda (amount)
      (if (>= balance amount)
	  (begin (set! balance (- balance amount))
		 balance)
	  "Insufficient funds"))
    initial-amount))

;; The environment model by this definition is following,
           +---------------------------+
 global -->| make-withdraw: --+        |
 env       +------------------|--------+
                              |      ^
                              V      |
                          .---.---.  |
                          | O | O-+--+
                          `-|-^---'
                            |
                            V
          parameters: initial-amount
          body:   (lambda (balance)
		    (lambda (amount)
		      (if (>= balance amount)
			  (begin (set! balance (- balance amount))
				 balance)
			  "Insufficient funds"))
		    initial-amount))


(define W1 (make-withdraw 100))
;; This environment model of the result is following,
            +-----------------------------------------------------+
            | make-withdraw: -----------------------------+       |
  global -->|                                             |       |
            | W1: --+                                     |       |
            +-------|-------------------------------------|-------+
                    |                ^                    |     ^
                    |                |   	          V     |
                    |        +-------+-------------+  .---.---. |
                    |  E1 -->| initial-amount: 100 |  | O | O-+-+
                    |        +-------+-------------+  `-|-^---'
                    |                ^                  |
                    |                |                  |
                    |        +-------+--------+         |
                    |  E2 -->| balance: 100   |         |
                    |        +----------------+         |
　　　　　　　　　　V                ^  	        |
                .---.---.            |  	        V
              +-+-O | O-+------------+  	    parameters: initial-amount
              | `---^---'               	    body: ...
              V
      parameters: amount
      body: (if (>= balance amount)
              (begin (set! balance (- balance amount))
		     balance)
              "Insufficient funds")


(W1 50)
;; This environment model of the result is following,
            +-----------------------------------------------------+
            | make-withdraw: -----------------------------+       |
  global -->|                                             |       |
            | W1: --+                                     |       |
            +-------|-------------------------------------|-------+
                    |                ^                    |     ^
                    |                |   	          V     |
                    |        +-------+-------------+  .---.---. |
                    |  E1 -->| initial-amount: 100 |  | O | O-+-+
                    |        +-------+-------------+  `-|-^---'
                    |                ^                  |
                    |                |                  |
                    |        +-------+------+           |
                    |  E2 -->| balance: 50  |           |
                    |        +--------------+           |
　　　　　　　　　　V                ^  	        |
                .---.---.            |  	        V
              +-+-O | O-+------------+  	    parameters: initial-amount
              | `---^---'               	    body: ...
              V
      parameters: amount
      body: (if (>= balance amount)
              (begin (set! balance (- balance amount))
		     balance)
              "Insufficient funds")

(define W2 (make-withdraw 100))
;; This environment model of the result is following,
            +---------------------------------------------------------------------------------+
            | make-withdraw: -----------------------------+                                   |
  global -->|                                             |                                   |
            | W2: ----------------------------------------|-----------------+                 |
            | W1: --+                                     |                 |                 |
            +-------|-------------------------------------|-----------------|-----------------+
                    |                ^                    |     ^           |               ^
                    |                |   	          V     |           |               |
                    |        +-------+-------------+  .---.---. | 	    |          +----+----------------+
                    |  E1 -->| initial-amount: 100 |  | O | O-+-+ 	    |    E3 -->| initial-amount: 100 |
                    |        +-------+-------------+  `-|-^---'   	    |          +---------------------+
                    |                ^                  |         	    |               ^
                    |                |                  |         	    |               |
                    |        +-------+------+           |         	    |          +----+----------+
                    |  E2 -->| balance: 50  |           |         	    |    E4 -->| balance: 100  |
                    |        +--------------+           |         	    |          +---------------+
　　　　　　　　　　V                ^  	        |                   |               ^
                .---.---.            |  	        V                   V               |
              +-+-O | O-+------------+      parameters: initial-amount  .---.---.           |
              | `---^---'                   body: ...                   | O | O +-----------+
              |                                                         `-+-^---'
              |                                                           |
              |    +------------------------------------------------------+
              |    |
              V    V
      parameters: amount
      body: (if (>= balance amount)
              (begin (set! balance (- balance amount))
		     balance)
              "Insufficient funds")

