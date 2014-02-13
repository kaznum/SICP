;; Serializing access to shared state

;; Serializers in Scheme
;; (define x 10)
;; (parallel-execute
;;  (lambda () (set! x (* x x)))
;;  (lambda () (set! x (+ x 1))))

(define x 10)
(define s (make-serializer))
(parallel-execute
 (s (lambda () (set! x (* x x))))
 (s (lambda () (set! x (+ x 1))))


;; to be continued
