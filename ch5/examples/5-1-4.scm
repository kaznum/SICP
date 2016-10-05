;; Using a Stack to Implement Recursion

(define (factorial n)
  (if (= n 1) 1 (* (factorial (- n 1)) n)))

(define (gcd a b)
  (if (= b 0) a (gcd b (remainder a b))))

;; The above examples are different from each other.
;; gcd reduces the original computation to the new gcd computation,
;; but new factorial computation's result is not the answer of the original gcd. ( N * (N - 1)! )


;; to be continued
