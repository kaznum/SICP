gcd-1
(test (op =) (reg b) (const 0))
(branch (label after-gcd-1))
(assign t (op rem) (reg a) (reg b))
(assign a (reg b))
(assign b (reg t))
(goto (label gcd-1))
after-gcd-1
...
gcd-2
(test (op =) (reg d) (const 0))
(branch (label after-gcd-2))
(assign s (op rem) (reg c) (reg d))
(assign c (reg d))
(assign d (reg s))
(goto (label gcd-2))
after-gcd-2

;; If the values in the registers of a and b are not needed by the time the controller gets to gcd-2,
;; the change can be done as follows,

gcd-1
(test (op =) (reg b) (const 0))
(branch (label after-gcd-1))
(assign t (op rem) (reg a) (reg b))
(assign a (reg b))
(assign b (reg t))
(goto (label gcd-1))
after-gcd-1
...
gcd-2
(test (op =) (reg b) (const 0))
(branch (label after-gcd-2))
(assign t (op rem) (reg a) (reg b))
(assign a (reg b))
(assign b (reg t))
(goto (label gcd-2))
after-gcd-2

;; Still, the controller has the two sequences which only differ in their entry-point label. => gcd subroutine
;; The subroutine returns to the correct point by checking the content of 'continue' register.
gcd
(test (op =) (reg b) (const 0))
(branch (label gcd-done))
(assign t (op rem) (reg a) (reg b))
(assign a (reg b))
(assign b (reg t))
(goto (label gcd))
gcd-done
(test (op =) (reg continue) (const 0))
(branch (label after-gcd-1))
(goto (label after-gcd-2))

(assign continue (const 0))
(goto (label gcd))
after-gcd-1
...
(assign continue (const 1))
(goto (label gcd))
after-gcd-2

;; The above is troublesome when there are many points which calls gcd,
;; which means that controller needs new expression not only to handle the content of 'continue' register as a entry-point label for the designated exiting point.(a special kind of constant)
;; but also which extends 'goto' instruction to allow execution to continue at the entry point described by the contents of a register.

gcd
(test (op =) (reg b) (const 0))
(branch (label gcd-done))
(assign t (op rem) (reg a) (reg b))
(assign a (reg b))
(assign b (reg t))
(goto (label gcd))
gcd-done
(goto (reg continue))

(assign continue (label after-gcd-1))
(goto (label gcd))
after-gcd-1
...
(assign continue (label after-gcd-2))
(goto (label gcd))
after-gcd-2
