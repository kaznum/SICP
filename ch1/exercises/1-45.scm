(define (average x y)
  (/ (+ x y) 2))
(define (average-damp f)
  (lambda (x) (average x (f x))))

;; definition of fixed-point
(define tolerance 0.00001)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (newline)
    (display guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

(define (compose f g)
  (lambda (x)
    (f (g x))))

(define (repeated f n)
  (if (< n 1)
      identity
      (compose f (repeated f (- n 1)))))

(define (sqrt x)
  (fixed-point (average-damp (lambda (y) (/ x y)))
               1.0))
(sqrt 2)
;; once

(define (cubert x)
  (fixed-point (average-damp (lambda (y) (/ x (* y y))))
               1.0))
(cubert 3.0)
;; once

(define (fourth-rt x)
  (fixed-point (average-damp (average-damp (lambda (y) (/ x (* y y y)))))
               1.0))

(fourth-rt 16)
;; twice


(define (fifth-rt x)
  (fixed-point (average-damp (average-damp (lambda (y) (/ x (* y y y y)))))
               1.0))
(fifth-rt 3.0)
;; twice

(define (sixth-rt x)
  (fixed-point (average-damp (average-damp (lambda (y) (/ x (* y y y y y)))))
               1.0))
(sixth-rt 3.0)
;; twice

(define (seventh-rt x)
  (fixed-point (average-damp (average-damp (lambda (y) (/ x (* y y y y y y)))))
               1.0))
(seventh-rt 3.0)
;; twice

(define (eighth-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y))))))
               1.0))
(eighth-rt 256)
;; 3 times

(define (nineth-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y))))))
               1.0))
(nineth-rt 512)
;; 3 times

(define (10th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y))))))
               1.0))
(10th-rt 1024)
;; 3 times

(define (11th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y))))))
               1.0))
(11th-rt 2048)
;; 3 times

(define (12th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y y))))))
               1.0))
(12th-rt 4096)
;; 3 times

(define (13th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y y y))))))
               1.0))
(13th-rt 8192)
;; 3 times

(define (14th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y y y y))))))
               1.0))
(14th-rt (* 8192 2))
;; 3 times

(define (15th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y y y y y))))))
               1.0))
(15th-rt (* 8192 4))
;; 3 times

(define (16th-rt x)
  (fixed-point (average-damp (average-damp (average-damp (average-damp (lambda (y) (/ x (* y y y y y y y y y y y y y y y)))))))
               1.0))
(16th-rt (* 8192 8))
;; 4 times

(define (nth-rt n x)
  (fixed-point
   ((repeated average-damp
	      (floor (/ (log n) (log 2))))
    (lambda (y) (/ x (expt y (- n 1)))))
   1.0))

(nth-rt 2 4)
(nth-rt 3 8)
(nth-rt 3 27)
(nth-rt 5 32)
