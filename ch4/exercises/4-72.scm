;; for flatten stream

;; (define (flatten-stream s)
;;   (if (stream-null? s)
;;       the-empty-stream
;;       (interleave-delayed
;;        (stream-car s)
;;        (delay (flatten-stream (stream-cdr s))))))

;; If the first element(stream) of the argument's stream is infinite,
;; the other elements(stream-cdr) will never evaluated forever.

;; for disjoin

;; (define (disjoin disjuncts frame-stream)
;;   (if (empty-disjunction? disjuncts)
;;       the-empty-stream
;;       (interleave-delayed
;;        (qeval (first-disjunct disjuncts) frame-stream)
;;        (delay (disjoin (rest-disjuncts disjuncts) frame-stream)))))

;; If the frame-stream or generated frame stream by (qeval (first-disjunct ...)) become infinite,
;; the the other elements are not evaluated forever.
