;; Design Register Machines

;; We must design 'data-path' (registers and operations)

;;; Euclid's Algorithm

(define (gcd a b)
  (if (= b 0)
      a
      (gcd b (remainder a b))))

;; register 'a', 'b', 't' (temporary)
;; 1. The result (remainder a b) is placed in 't'.
;; 2. The content 'b' is placed to 'a'
;; 3. The content 't' is placed to 'b'

;; The source of a register assignment can be 'another register', 'an operation result' or 'a constant'.

;; to be continued
