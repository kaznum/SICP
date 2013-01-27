;; x |-> 1 + 1/x

;;[phi] = (1 + [sqrt]5)/2 ~= 1.6180

;; The steps of transformation are following
;; (2 * phi) - 1 = 5^(1/2)
;; ((2 * phi) - 1)^2 = 5
;; 4 * phi^2 - 4 * phi + 1 = 5
;; phi^2 - phi - 1 = 0
;; phi^2 = phi + 1
;; phi = 1 + 1/phi


;; define fixed-point
(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2)
    (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
      (if (close-enough? guess next)
	  next
	  (try next))))
  (try first-guess))

;; calcurate phi by fixed-point process
(define (phi)
  (fixed-point (lambda (x) (+ 1 (/ 1 x)))
	       1.0))
(phi)

;; calcurate phi by average damping
(define (phi)
  (fixed-point (lambda (x) (average x (+ 1 (/ 1 x))))
	       1.0))
(phi)



