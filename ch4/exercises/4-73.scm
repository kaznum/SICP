(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")


;; ;; original definition From text

;; (define (flatten-stream s)
;;   (if (stream-null? s)
;;       the-empty-stream
;;       (interleave-delayed
;;        (stream-car s)
;;        (delay (flatten-stream (stream-cdr s))))))

;; ;; the definition of ex4.73
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))

(define orig-flatten-stream flatten-stream)

(define (ex-flatten-stream stream)
  (if (stream-null? stream)
      the-empty-stream
      (interleave
       (stream-car stream)
       (flatten-stream (stream-cdr stream)))))

(define (flatten-stream stream)
  (newline)
  (display (number->string (count-up)))
  (orig-flatten-stream stream))
;;  (ex-flatten-stream stream))

(define counter 0)
(define (count-up)
  (set! counter (+ 1 counter))
  counter)

(define sample "
    (assert! (rule (same ?x ?x)))
    (assert! (rule (element? ?x (?y . ?z))
                   (or (same ?x ?y)
                       (element? ?x ?z))))
    (assert! (as x y))
    (assert! (as y z))
    (assert! (as w m))
    (or (and (as x ?m) (element? ?m (a b y d e)))
        (and (as y ?n) (element? ?n (a b y d e))))
")

(query-driver-loop)

;; With the definition of flatten-stream of ex4.73, the second argument of 'interleave' is evaluated
;; applicatively in advance, so the flatten-stream returns the result after all elements have been manipulated

