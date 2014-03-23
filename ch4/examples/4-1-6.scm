(define (f x)
  (define (even? n) (if (= n 0) true (odd? (- n 1))))
  (define (odd? n) (if (= n 0) false (even? (- n 1))))
  ;; <rest of body of f>
  )

(lambda <vars>
  (define u <e1>)
  (define v <e2>)
  <e3>)

(lambda <vars>
  (let ((u '*unassigned*)
	(v '*unassigned*))
    (set! u <e1>)
    (set! v <e2>)
    <e3>))
