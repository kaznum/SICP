;; when fibs' definition is based on add-stream, all results are cached, and initial 2 elements are just initial values so, the number of addition to computer the nth Fibonacci number is "n - 2", The order is O(n)

;; If (delay <exp>) is defined as (lambda () <exp>), the results which computed before are not cached.
;; For example, to get the 5th element of Fibs, we need 4 additions as follows,
;;   4th elem + 3rd elem (+1)
;;     to get 4th elem, 2nd elem + 3rd elem (+1)
;;        to get 3rd elem, 1st elem + 2nd elem (+1) 
;;     to get 3rd elem, 1st elem + 2nd elem (+1)
;; to get the 6th element of Fibs, we need 6 additions as follows,
;;   5th elem + 4th elem (+1)
;;     to get 5th elem, 4th elem + 3rd elem (+1)
;;     to get 4th elem, as before (+2)
;;   to get 4th elem, as before (+2)
;;
;; Like this, if the results are not cached, to get one element of fibs, we need to calcuration each elements many times. The order is O(2^n)
