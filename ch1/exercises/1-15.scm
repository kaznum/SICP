(define (cube x) (* x x x))

(define (p x) (- (* 3 x) (* 4 (cube x))))

(define (sine angle)
  (if (not (> (abs angle) 0.1))
      angle
      (p (sine (/ angle 3.0)))))
;; a.
;;
;; (sine 12.15)
;; (p (sine (/ 12.15 3.0)))
;; (p (sine 4.05))
;; (p (p (sine (/ 4.05 3.0))))
;; (p (p (sine 1.35)))
;; (p (p (p (sine (/ 1.35 3.0)))))
;; (p (p (p (sine 0.45))))
;; (p (p (p (p (sine (/ 0.45 3.0))))))
;; (p (p (p (p (sine 0.15)))))
;; (p (p (p (p (p (sine 0.05))))))
;;
;; 'p' is applied 5 times

;; b.
;;
;; The step count becomes the minimum n which is sufficient for 3^n >= a / 0.1
;; so, n >= log(a/0.1) / log3  = (log(a) + 1)/log(3)
;;
;; both of the order of growth of space and number are [theta](log(a))



