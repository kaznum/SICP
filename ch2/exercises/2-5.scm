(define (cons a b) (* (expt 2 a) (expt 3 b)))

(define (count-of-power base n)
  (if (= (remainder n base) 0)
      (+ 1 (count-of-power base (/ n base)))
      0))

;; a is the power of 2 in the 2^a * 3^b
(define (car pair)
  (count-of-power 2 pair))

;; b is the power of 3 in the 2^a * 3^b
(define (cdr pair)
  (count-of-power 3 pair))

(car (cons 9 0))
(car (cons 1 9))
(cdr (cons 1 9))
(cdr (cons 2 5))


;; another answer of cdr which uses car
(define (cdr pair)
  (round (/ (log (/ pair (expt 2 (car pair)))) (log 3))))
