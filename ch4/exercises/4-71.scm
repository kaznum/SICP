(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")

;; ;; original in text
;; (define (simple-query query-pattern frame-stream)
;;   (stream-flatmap
;;    (lambda (frame)
;;      (stream-append-delayed ;; *
;;       (find-assertions query-pattern frame)
;;       (delay (apply-rules query-pattern frame)))) ;; **
;;    frame-stream))

;; (define (disjoin disjuncts frame-stream)
;;   (if (empty-disjunction? disjuncts)
;;       the-empty-stream
;;       (interleave-delayed ;; ***
;;        (qeval (first-disjunct disjuncts) frame-stream)
;;        (delay (disjoin (rest-disjuncts disjuncts) frame-stream))))) ;; ****
;; (put 'or 'qeval disjoin)


;; from exercise 4.71
(define (simple-query query-pattern frame-stream)
  (stream-flatmap
   (lambda (frame)
     (stream-append ;; *
      (find-assertions query-pattern frame)
      (apply-rules query-pattern frame))) ;; **
   frame-stream))

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave ;; ***
       (qeval (first-disjunct disjuncts)
              frame-stream)
       (disjoin (rest-disjuncts disjuncts) ;; ****
                frame-stream))))
(put 'or 'qeval disjoin)


(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
                   (interleave s2 (stream-cdr s1)))))


(define sample "

(assert! (say bye 1))
(assert! (say bye 2))
(assert! (say hello 1))
(assert! (say hello 2))
(assert! (rule (disp ?x ?y) (say ?y ?x)))
(assert! (rule (same ?x ?x)))
(and (say bye ?x)
     (not (same ?x 2)))
(and (say bye ?x) (say hello ?y) (same ?x ?y) (lisp-value > ?x 1))
(and (say bye ?x) (say hello ?y) (same ?x ?y) (not (lisp-value > ?x 1)))
(and (say bye ?x) (say hello ?y) (or (lisp-value > ?x 1) (same ?x ?y)))
(or (say bye ?x) (say hello ?x))

")

(query-driver-loop)

;; ;; Answer
;; The Louis example evaluates the find-assertion and apply-rules simultaneously, but Text example evaluates apply-rules lazyly, so
;; the Louis one does not support the infinite frame stream.

;; Text example

;;; Query input:
;; (assert! (a 2))
;; Assertion added to data base.
;;; Query input:
;; (assert! (rule (x) (a ?m)))
;; Assertion added to data base.
;;; Query input:
;; (x)
;;; Query result:
;; (x)
;;; Query input:
;; (assert! (rule (a ?x) (a ?x)))
;; Assertion added to data base.
;;; Query input:
;; (x)
;;; Query result:
;; (x)
;; (x)
;; (x)
;; (x)
;; (x)
;; ...
;; ...
;; ...

;; Exercise 4.71's example

;; ;;; Query input:
;; (assert! (a 2))
;; Assertion added to data base.
;; ;;; Query input:
;; (assert! (rule (x) (a ?m)))
;; Assertion added to data base.
;; ;;; Query input:
;; (x)
;; ;;; Query result:
;; (x)
;; ;;; Query input:
;; (assert! (rule (a ?x) (a ?x)))
;; Assertion added to data base.
;; ;;; Query input:
;; (x)
;; ;;; Query result:
;; ;... aborted
;; ;Aborting!: maximum recursion depth exceeded

