(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (stream-append-delayed
        (stream-cdr s1)
        delayed-s2))))

;; interleave:
;; s1: '(1 2 3), s2: '(4 5 6 7 8)
;; result: '(1 4 2 5 3 6 7 8)
(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
      (force delayed-s2)
      (cons-stream
       (stream-car s1)
       (interleave-delayed
        (force delayed-s2)
        (delay (stream-cdr s1))))))

;; proc <a frame> generates the multiple streams of frames
(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream s)
  (if (stream-null? s)
      the-empty-stream
      (interleave-delayed
       (stream-car s)
       (delay (flatten-stream (stream-cdr s))))))

(define (singleton-stream x)
  (cons-stream x the-empty-stream))
