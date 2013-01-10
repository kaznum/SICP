(define (p) (p))
(define (test x y)
  (if (= x 0)
      0
      y))

(test 0 (p))


;; applicative-order evaluation
;; (test 0 (p))  ;; now evaluating (p)
;; -> (if (= 0 0) 0 (p)) ;; do not come here because (p) is infinite loop

;; normal-order
;; (test 0 (p))
;; -> (if (= 0 0) 0 (p))  ;; substitute with the arguments
;; -> (if (= 0 0) 0 (p))  ;; evaluate the most inner combination which is only required evaluation now
;; -> (if (#t) 0 (p)) ;; evaluation the condition
;; -> 0

;; The result of the execution does not response, so this is evaluating the consequent expression.
