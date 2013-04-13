(define (make-monitored f)
  (let ((calls 0))
    (define (mf x)
      (cond ((eq? x 'how-many-calls?) calls)
	    ((eq? x 'reset-count) (set! calls 0))
	    (else
	     (begin (set! calls (+ calls 1))
		    (f x)))))
    mf))

;; TEST
(define s (make-monitored sqrt))

(s 100)

(s 'how-many-calls?)
(s 40)

(s 'how-many-calls?)
(s 50)
(s 200)
(s 400)
(s 'how-many-calls?)
(s 'reset-count)
(s 50)
(s 'how-many-calls?)

