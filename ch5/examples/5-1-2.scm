;; Abstraction in Machine Design

(define (remainder n d)
  (if (< n d)
      n
      (remainder (- n d) d)))

;; from ch5.1.1
(controller
 test-b
 (test (op =) (reg b) (const 0))
 (branch (label gcd-done))
 (assign t (op rem) (reg a) (reg b)) ;; replaced
 (assign a (reg b))
 (assign b (reg t))
 (goto (label test-b))
 gcd-done)


;; elaborated
(controller
 test-b
 (test (op =) (reg b) (const 0))
 (branch (label gcd-done))
 ;; (assign t (op rem) (reg a) (reg b)) replacement starts
 (assign t (reg a)
 rem-loop
 (test (op <) (reg t) (reg b))
 (branch (label rem-done))
 (assign t (op -) (reg t) (reg b))
 (goto rem-loop)
 rem-done  ;; end of the replacement
 (assign a (reg b))
 (assign b (reg t))
 (goto (label test-b))
 gcd-done)
