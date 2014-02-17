(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
	      (cons proc (map stream-cdr argstreams))))))

;; TEST
(define result (stream-map + (cons-stream 1 (cons-stream 2 the-empty-stream)) (cons-stream 3 (cons-stream 4 the-empty-stream)) (cons-stream 5 (cons-stream 6 the-empty-stream))))

(stream-car result)
(stream-car (stream-cdr result))


