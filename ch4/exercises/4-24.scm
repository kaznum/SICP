;; Calcurate factorial 3000 * 100 times)
;; See the result of 4-24-analyze.scm and 4-24-eval.scm
;;
;; The ratio is 50sec : 86sec
;; The fraction is 86/50 = 1.72 times
;; This difference is for redundant syntactic analysis.
;; The evaluations of (if ..), (= n 1), (factorial ..) and (- n 1)
;; are called the same times as the loop count on metacircular version.
