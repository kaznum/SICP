;;
;; define iterative-improve
;;
(define (iterative-improve good-enough? improve)
  (define (try guess)
    (if (good-enough? guess)
	guess
	(try (improve guess))))
  try)

;;
;; define sqrt with iterative-improve
;;
(define tolerance 0.00001)

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x)
  ((iterative-improve
   (lambda (guess) (< (abs (- (square guess) x)) tolerance))
   (lambda (guess) (average guess (/ x guess))))
   1.0))

;; TEST
(sqrt 5)
(sqrt 8)
(sqrt 9)

;;
;; define fixed-point with iterative-improve
;;
(define (fixed-point f first-guess)
  ((iterative-improve
   (lambda (guess) (< (abs (- guess (f guess))) tolerance))
   f)
   first-guess))

;; TEST
(fixed-point cos 1.0)
