;; (1) par1's Taylor expansion
;;
;; (R1 R2) / (R1 + R2)
;; = (R1_0 R2_0) / (R1_0 + R2_0)
;;     + (R2_0 / (R1_0 + R2_0) - (R1_0 R2_0) / (R1_0 + R2_0)^2) * (R1 - R1_0)
;;     + (R1_0 / (R1_0 + R2_0) - (R1_0 R2_0) / (R1_0 + R2_0)^2) * (R2 - R2_0)
;;     + O(R1 - R1_0)^2 + O(R2 - R2_0)^2 ...
;;
;; When R1 = R1_0 + w, R2 =  (where w << 1) then O(R - R_0) << 1 which is ignorable.

;; (2) par2's Taylor expansion

;; 1 / ( 1 / (1 / R1) + 1 / (1 / R2))
;; = ... =~ (2)

;; From above, for the small tolerance, when expand algebraic expression by Taylor expansion, this expression is converted to the linear expression. Each parameters with tolerances can be appended to this linear expression and answer without the shortcoming.








