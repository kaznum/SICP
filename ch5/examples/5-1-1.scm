;; Data path and Controller definition of GCD

(data-paths
 (registers
  ((name a)
   (buttons ((name a<-b) (source (register b)))))
  ((name b)
   (buttons ((name b<-t) (source (register t)))))
  ((name t)
   (buttons ((name t<-r) (source (operation rem))))))
 (operations
  ((name rem) (inputs (register a) (register b)))
  ((name =) (inputs (register b) (constant 0)))))

(controller
 test-b  ; label
 (test =) ; test
 (branch (label gcd-done)) ; conditional branch. If the previous test fails, continues to the instruction of the label, otherwise, continues with the next instruction
 (t<-r)   ; button push
 (a<-b)   ; button push
 (b<-t)   ; button push
 (goto (label test-b))  ; unconditional branch
 gcd-done)  ; label

;; Description only by controller
(controller
 test-b
 (test (op =) (reg b) (const 0))
 (branch (label gcd-done))
 (assign t (op rem) (reg a) (reg b))
 (assign a (reg b))
 (assign b (reg t))
 (goto (label test-b))
 gcd-done)

;; The above one has some disadvantages.
;; 1. The descriptions of the data-path elements are repeated whenever the elements are mentioned in the controller.
;; 2. It's very difficult to know how many registeres, operations, and buttons there are and how they are interconnected.
;; 3. Operation can operate only on constants and the contents of  registers, not on the results of other operations.
