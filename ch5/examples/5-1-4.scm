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

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1) (fib (- n 2))))))

;; controller

(controller
 (assing continue (label fib-done))

 fib-loop
 (test (op <) (reg n) (const 2))
 (branch (label immediate-answer))
 ;; set up to computer Fib(n - 1)
 (save continue)
 (assign continue (label afterfib-n-1))
 (save n) ; save old value of n
 (assign n (op -) (reg n) (const 1)) ; clobber n to n-1
 (goto (label fib-loop)) ; perform recursive call　

 afterfib-n-1 ; upon return, val contains Fib(n - 2)
 (restore n)
 (restore continue)
 ;; set up to compile Fib(n - 2)
 (assign n (op -) (reg n) (const 2))
 (save continue)   ;; PUSH just almost after POP in the stack, which just wants to get the first value of the stack but keep it.(not pop)
 (assign continue (labelfib-n-2))
 (save val)  ; save Fib(n - 1)
 (goto (label fib-loop))

 afterfib-n-2  ; upon return, val contains Fib(n - 2)
 (assign n (reg val))  ; n now contains Fib(n - 2)
 (restore val)   ; val now contains Fib(n - 1)
 (restore continue)
 (assign val
         (op +) (reg val) (reg n)) ; Fib(n - 1) + Fib(n - 2)
 (goto (reg continue))  ; return to caller, answer is in val

 immediate-answer
 (assign val (reg n))  ; base case: Fib(n) = n
 (goto (reg continue))

 fib-done)



;; fib(4)

;; continue stack: []
;; n stack: []
;; val stack: []
;; continue reg: nil
;; n reg: nil
;; val reg: nil

;; ->

;; continue stack: [fib-done]
;; n stack: [4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 3
;; val reg: nil

;; ->

;; continue stack: [afterfib-n-1 fib-done]
;; n stack: [3 4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 2
;; val reg: nil

;; ->

;; continue stack: [afterfib-n-1 afterfib-n-1 fib-done]
;; n stack: [2 3 4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 1
;; val reg: nil


;; ->

;;;; (test (op <) (reg n) (const 2)) => truthy => jump to 'immediate-answer'
;;;; in immediate-answer

;; continue stack: [afterfib-n-1 afterfib-n-1 fib-done]
;; n stack: [2 3 4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 1
;; val reg: 1


;; ->

;;;; in afterfib-n-1

;; continue stack: [afterfib-n-1 afterfib-n-1 fib-done]
;; n stack: [3 4]
;; val stack: [1]
;; continue reg: afterfib-n-2
;; n reg: 2 -> 0
;; val reg: 1

;; ->

;;;; in fib-loop

;;;; (test (op <) (reg n) (const 2)) => truthy => jump to 'immediate-answer'
;;;; in immediate-answer

;; continue stack: [afterfib-n-1 afterfib-n-1 fib-done]
;; n stack: [3 4]
;; val stack: [1]
;; continue reg: afterfib-n-2
;; n reg: 0
;; val reg: 0

;; ->

;;;; in afterfib-n-2

;; continue stack: [afterfib-n-1 fib-done]
;; n stack: [3 4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 1
;; val reg: 1

;; ->

;;;; in afterfib-n-1

;; continue stack: [afterfib-n-1 fib-done]
;; n stack: [4]
;; val stack: [1]
;; continue reg: afterfib-n-2
;; n reg: 3 -> 1
;; val reg: 1

;; ->

;;;; in fib-loop

;;;; jump to immediate-answer

;; continue stack: [afterfib-n-1 fib-done]
;; n stack: [4]
;; val stack: [1]
;; continue reg: afterfib-n-2
;; n reg: 1
;; val reg: 1


;; ->

;;;; in afterfib-n-2

;; continue stack: [ fib-done]
;; n stack: [4]
;; val stack: []
;; continue reg: afterfib-n-1
;; n reg: 1
;; val reg: 1 -> 2


;; ->

;;;; in afterfib-n-1

;; continue stack: [fib-done]
;; n stack: [4]
;; val stack: [2]
;; continue reg: afterfib-n-2
;; n reg: 4 -> 2
;; val reg: 1 -> 2

;; ->

;;;; in fib-loop

;; continue stack: [afterfib-n-2 fib-done]
;; n stack: [2 4]
;; val stack: [2]
;; continue reg: afterfib-n-1
;; n reg: 2 -> 1
;; val reg: 2

;; ->

;;;; in fib-loop
;;;; jump to immediate-answer

;; continue stack: [afterfib-n-2 fib-done]
;; n stack: [2 4]
;; val stack: [2]
;; continue reg: afterfib-n-1
;; n reg: 1
;; val reg: 1


;; ->

;;;; in afterfib-n-1

;; continue stack: [afterfib-n-2 fib-done]
;; n stack: [4]
;; val stack: [1 2]
;; continue reg: afterfib-n-2
;; n reg: 2 -> 0
;; val reg: 1


;; ->

;;;; in fib-loop
;;;; jump to immediate-answer

;; continue stack: [afterfib-n-2 fib-done]
;; n stack: [4]
;; val stack: [1 2]
;; continue reg: afterfib-n-2
;; n reg: 0
;; val reg: 0

;; ->

;;;; in afterfib-n-2

;; continue stack: [fib-done]
;; n stack: [4]
;; val stack: [2]
;; continue reg: afterfib-n-2
;; n reg: 0
;; val reg: 1

;; ->

;;;; in afterfib-n-2

;; continue stack: []
;; n stack: [4]
;; val stack: []
;; continue reg: fib-done
;; n reg: 1
;; val reg: 3


;; ->
;; fib-done

;; continue stack: []
;; n stack: [4]
;; val stack: []
;; continue reg: fib-done
;; n reg: 1
;; val reg: 3

;; The answer is 3
