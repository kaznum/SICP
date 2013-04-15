(define rand
  (let ((x random-init))
    (define (generate)
      (set! x (rand-update x))
      x)
    (define (reset init)
      (set! x init))
    (lambda (s)
      (cond ((eq? s 'generate) (generate))
	    ((eq? s 'reset) reset)
	    (else (error "The symbol is not supported" s))))))


;; TEST
(define random-init 1)
(define (rand-update i)
  (+ i 1))

(rand 'generate)
((rand 'reset) 1)
(rand 'hoge)
