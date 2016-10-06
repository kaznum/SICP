;; Using a Stack to Implement Recursion

(define (factorial n)
  (if (= n 1) 1 (* (factorial (- n 1)) n)))

(define (gcd a b)
  (if (= b 0) a (gcd b (remainder a b))))

;; The above examples are different from each other.
;; gcd reduces the original computation to the new gcd computation,
;; but new factorial computation's result is not the answer of the original gcd. ( N * (N - 1)! )

;; In the subproblem, the contents of the registeres will be different than they were in the main problem, then store the contents of the registers which are needed after the subproblem is solved in order to restore to continue the suspended computation.

;; Use 'stack' which enables 'last-in, first-out' to save the contents of the registers.

;; To satisfy this, we add two instructions, 'save' and 'restore'.
;; So as to 'continue' register.

(controller
 (assign continue (label (fact-done)))
 fact-loop
 (test (op =) (reg n) (const 1))
 (branch (label base-case))
 (save continue)
 (save n)
 (assign n (op -) (reg n) (const 1))
 (assign continue (label after-fact))
 (goto (label fact-loop))
 after-fact
 (restore n)
 (restore continue)
 (assign val (op *) (reg n) (reg val))
 (goto (reg continue))
 base-case
 (assign val (const 1))
 (goto (reg continue))
 fact-done)

;; A double recursion

;; to be continued
