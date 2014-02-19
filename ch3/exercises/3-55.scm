(define (partial-sums s)
  (cons-stream (stream-car s) (add-streams (stream-cdr s) (partial-sums s))))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define integers
  (cons-stream 1 (stream-map (lambda (x) (+ x 1)) integers)))

(stream-ref integers 0)
;; 1
(stream-ref integers 1)
;; 2
(stream-ref integers 2)
;; 3
(stream-ref integers 3)
;; 4

(define p-s (partial-sums integers))

(stream-ref p-s 0)
;; 1
(stream-ref p-s 1)
;; 3 (1 + 2)
(stream-ref p-s 2)
;; 6 (1 + 2 + 3)
(stream-ref p-s 3)
;; 10
(stream-ref p-s 4)
;; 15

