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

;; to be continued
