(define (stream-append-delay s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (stream-append-delay
        (stream-cdr s2)
        delayed-s2))))

;; interleave:
;; s1: '(1 2 3), s2: '(4 5 6 7 8)
;; result: '(1 4 2 5 3 6 7 8)
(define (interleave-delay s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (interleave-delay
        (force delayed-s2)
        (delay (stream-cdr s1))))))

;; proc <a frame> generates the multiple streams of frames
(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream s)
  (if (stream-null? s)
      the-empty-stream
      (interleave-delay
       (stream-car s)
       (delay (flatten-stream (stream-cdr s))))))

(define (singleton-stream x)
  (stream-cons x the-empty-stream))
