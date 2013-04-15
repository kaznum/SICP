;; Given in the section
(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
	   (/ trials-passed trials))
	  ((experiment)
	   (iter (- trials-remaining 1) (+ trials-passed 1)))
	  (else
	   (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

;; Given in the explanation of the exercise
(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

;; Answer
(define (estimate-pi trials)
  (define (P x y)
    (<= (+ (* x x) (* y y)) 1))
  (estimate-integral P -1.0 1.0 -1.0 1.0 trials))

(define (estimate-integral P x1 x2 y1 y2 trials)
  (define (range-test)
    (let ((x (random-in-range x1 x2))
	  (y (random-in-range y1 y2)))
      (P x y)))
  (* (* (- x2 x1) (- y2 y1)) (monte-carlo trials range-test)))

;; 1 ]=> (estimate-pi 1000)
;Value: 3.136
;; 1 ]=> (estimate-pi 100000)
;Value: 3.14236

