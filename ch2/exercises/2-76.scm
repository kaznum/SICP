;; Explicit dispatch style : ch2.4.2's way
;; Data-directed style: the way of the first-half of ch2.4.3.
;; Message-passing style: the way of the section 'Message passing' in ch2.4.3.


;; Q) most appropriate for a system in which new types must often be added
;; A)
;; Message passing style or Data-directed style are more appropriate
;; because there is no need to modify the codes of other types implementation.
;; Additionally, message-passing is the easiest way only if it is needed to implement
;; selector with one argument (the target itself)
;; With explicity dispatch style, new type definition has to be implemented and
;; the generic procedure has to be changed.


;; Q) most appropriate for a system in which new operations must often be added
;; A)
;; Data-directed or Message-passing styles are more appropriate too.
;; because in every styles the definition needs to be changed, but
;; especially, explicit style needs to be cared about the naming conflicts
;; and have to modify the condition clauses in the generic procedures.
