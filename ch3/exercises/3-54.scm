(define (mul-streams s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      the-empty-stream
      (cons-stream (*
		    (stream-car s1) (stream-car s2))
		   (mul-streams (stream-cdr s1) (stream-cdr s2)))))

;; or
(define (mul-streams s1 s2)
  (stream-map * s1 s2))

;; integers-starting-from is defined in the text
(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define factorials
  (cons-stream 1 (mul-streams (integers-starting-from 2) factorials)))

;; mul-streams' test
(define s1 (cons-stream 1 (cons-stream 2 (cons-stream 3 the-empty-stream))))
(define s2 (cons-stream 4 (cons-stream 5 (cons-stream 6 the-empty-stream))))
(define mul-s (mul-streams s1 s2))

(stream-ref mul-s 0)
(stream-ref mul-s 1)
(stream-ref mul-s 2)

;; factorials' test
(stream-ref factorials 0)
(stream-ref factorials 1)
(stream-ref factorials 2)
(stream-ref factorials 3)
(stream-ref factorials 4)
(stream-ref factorials 5)
(stream-ref factorials 6)




