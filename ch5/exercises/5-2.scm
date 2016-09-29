;; 1. description by data-path and operation separately

(data-path
 (registers
  ((name p)
   (buttons
    ((name p<-1) (source (constant 1)))
    ((name p<-tp) (source (register tp)))))
  ((name tp)
   (buttons
    ((name tp<-*) (source (operation *)))))
  ((name c)
   (buttons
    ((name c<-1) (source (constant 1)))
    ((name c<-tc) (source (register tc)))))
  ((name tc)
   (buttons
    ((name tc<-+) (source (operation +)))))
  ((name n)))
 (operations
  ((name *) (inputs (register p) (register c)))
  ((name +) (inputs (register c) (constant 1)))
  ((name >) (inputs (register c) (register n)))))

(controller
 initialize
 (p<-1)
 (c<-1)
 test-cp
 (test >)
 (branch (label factorial-done))
 (tp<-*)
 (tc<-+)
 (p<-tp)
 (c<-tc)
 (goto (label test-cp))
 factorial-done)


;; Combined into a controller
(controller
 initialize
 (assign p (const 1))
 (assign c (const 1))
 test-cp
 (test (op >) (reg c) (reg n))
 (branch (label factorial-done))
 (assign tp (op *) (reg p) (reg c))
 (assign tc (op +) (reg c) (const 1))
 (assign p (reg tp))
 (assign c (reg tc))
 (goto (label test-cp))
 factorial-done)
