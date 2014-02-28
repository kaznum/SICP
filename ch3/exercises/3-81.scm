(define random-init 1)
(define (rand-update i)
  (+ i 1))

(define (stream-map2 f s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      the-empty-stream
      (cons-stream (f (stream-car s1) (stream-car s2))
		   (stream-map2 f (stream-cdr s1) (stream-cdr s2)))))

(define (rand random-init commands)
  (define (interpret seed command)
    (if (eq? command 'generate)
	(rand-update seed)
	(cdr command)))
  (define (random-numbers random-init)
    (cons-stream
     random-init
     (stream-map2 interpret (random-numbers random-init) commands)))
  (random-numbers random-init))

;; test
(define coms
  (cons-stream 'generate
	       (cons-stream 'generate
			    (cons-stream (cons 'reset 100)
					 (cons-stream 'generate the-empty-stream)))))



(define random-s (rand 10 coms))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

(show-stream random-s 5)

;; 10
;; 11
;; 12
;; 100
;; 101
