(define x 10)
(define s (make-serializer))
(parallel-execute (lambda () (set! x ((s (lambda () (* x x))))))
                  (s (lambda () (set! x (+ x 1)))))

;; the atomit processes are
;; (* x x)
;; (set! x (+ x 1))

;; So posible sequence is as follows.

;; 1. (* x x) -> (set! x ..) -> (set! x (+ x 1)) : 101
;; 2. (* x x) -> (set! x (+ x 1)) -> (set! x ..) : 100
;; 3. (set! x (+ x 1)) -> (* x x) -> (set! x ..) : 121

;; The answer is 101,100,121
