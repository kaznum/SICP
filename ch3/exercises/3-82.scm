;; Given in the explanation of the exercise
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

;; Answer
(define (monte-carlo-stream experiment)
  (define (passes-and-trials-stream passes trials)
    (if (experiment)
	(cons-stream (cons (+ passes 1) (+ trials 1))
		     (passes-and-trials-stream (+ passes 1) (+ trials 1)))
	(cons-stream (cons passes (+ trials 1))
		     (passes-and-trials-stream passes (+ trials 1)))))
  (stream-map (lambda (p) (/ (car p) (cdr p)))
	      (passes-and-trials-stream 0 0)))

(define estimate-pi-stream
  (let ((P (lambda (x y)
	     (<= (+ (* x x) (* y y)) 1))))
    (estimate-integral-stream P -1.0 1.0 -1.0 1.0)))

(define (estimate-integral-stream P x1 x2 y1 y2)
  (define (range-test)
    (let ((x (random-in-range x1 x2))
	  (y (random-in-range y1 y2)))
      (P x y)))
  (scale-stream (monte-carlo-stream range-test) (* (* (- x2 x1) (- y2 y1)))))

(define (scale-stream s v)
  (stream-map (lambda (x) (* v x)) s))

(stream-ref estimate-pi-stream 1000)
;Value: 3.136863136863137
(stream-ref estimate-pi-stream 100000)
;Value: 3.146928530714693
(stream-ref estimate-pi-stream 200000)
;Value: 3.139844300778496
(stream-ref estimate-pi-stream 400000)
;Value: 3.139802150494624
