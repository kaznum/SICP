(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")


;; TEST the behavior of stream-filter
;; 1 ]=> (define integers (cons-stream 1 (stream-map (lambda (x) (+ 1 x)) integers)))
;; ;Value: integers
;; 1 ]=> (stream-car (stream-filter (lambda (x) (< x 3)) integers))
;; ;Value: 1
;; 1 ]=> (stream-car (stream-cdr (stream-filter (lambda (x) (< x 3)) integers)))
;; ;Value: 2
;; 1 ]=> (stream-car (stream-cdr (stream-cdr (stream-filter (lambda (x) (< x 3)) integers))))
;; ; no result


;;;; Original definitions from text

;; (define (negate operands frame-stream)
;;   (stream-flatmap
;;    (lambda (frame)
;;      (if (stream-null? (qeval (negated-query operands) (singleton-stream frame)))
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))

;; (put 'not 'qeval negate)

;; (define (lisp-value call frame-stream)
;;   (stream-flatmap
;;    (lambda (frame)
;;      (if (execute
;;           (instantiate
;;            call
;;            frame
;;            (lambda (v f)
;;              (error "Unknown pat var: LISP-VALUE" v))))
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))
;; (put 'lisp-value 'qeval lisp-value)

;; (define (stream-flatmap proc s)
;;   (flatten-stream (stream-map proc s)))
;; (define (flatten-stream s)
;;   (if (stream-null? s)
;;       the-empty-stream
;;       (interleave-delayed
;;        (stream-car s)
;;        (delay (flatten-stream (stream-cdr s))))))

;;;; a.

;; (define (simple-stream-flatmap proc s)
;;   (simple-flatten (stream-map proc s)))
;; (define (simple-flatten stream)
;;   (stream-map stream-car
;;               (stream-filter (lambda (x) (not (stream-null? x)))
;;                              stream)))


;; (define (negate operands frame-stream)
;;   (simple-stream-flatmap
;;    (lambda (frame)
;;      (if (stream-null? (qeval (negated-query operands) (singleton-stream frame)))
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))
;; (put 'not 'qeval negate)

;; (define (lisp-value call frame-stream)
;;   (simple-stream-flatmap
;;    (lambda (frame)
;;      (if (execute
;;           (instantiate
;;            call
;;            frame
;;            (lambda (v f)
;;              (error "Unknown pat var: LISP-VALUE" v))))
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))
;; (put 'lisp-value 'qeval lisp-value)

;; (define (find-assertions pattern frame)
;;   (simple-stream-flatmap
;;    (lambda (datum)
;;      (check-an-assertion datum pattern frame))
;;    (fetch-assertions pattern frame)))

(define samples "

(assert! (a 1))
(assert! (a 2))
(assert! (a 3))
(assert! (b 1))
(assert! (b 2))
(assert! (b 3))

(and (a ?m) (b ?m) (or (lisp-value > ?m 1) (lisp-value < ?m 3)))

")

;;;; b.
;; I don't think there is any change....

