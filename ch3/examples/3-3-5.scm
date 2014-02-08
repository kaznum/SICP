;;; 9C = 5(F-32)

;;
;;       +--------+       +--------+   v   +--------+
;; C-----| m1     |   u   |     m1 |-------| a1     |
;;       |      p |-------| p      |       |      s |-----F
;;     +-| m2     |       |     m2 |-+   +-| a2     |
;;     | +--------+       +--------+ |   | +--------+
;;    w|                            x|   |y
;;     |   +---+             +---+   |   |   +----+
;;     +---| 9 |             | 5 |---+   +---| 32 |
;;         +---+             +---+           +----+
;;

;;; Using the constraint system

(define C (make-connector))
(define F (make-connector))
(celsius-fahrenheit-converter C F)

(define (celsius-fahrenheit-converter c f)
  (let ((u (make-connector))
	(v (make-connector))
	(w (make-connector))
	(x (make-connector))
	(y (make-connector)))
    (multiplier c w u)
    (multiplier v x u)
    (adder v y f)
    (constant 9 w)
    (constant 5 x)
    (constant 32 y)
    'ok))

(probe "Celsius temp" C)
(probe "Fahrenheit temp" F)

(set-value! C 25 'user)
(set-value! F 212 'user) ;; error

(forget-value! C 'user)
(set-value! F 212 'user) ;; no error

;;; Implementing the constraint system

