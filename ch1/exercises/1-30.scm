;; linear recursive procedure
;; (define (sum term a next b)
;;   (if (> a b)
;;       0
;;       (+ (term a)
;; 	 (sum term (next a) next b))))

;; iterative procedure
(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a) (+ result (term a)))))
  (iter a 0))
(define (inc n) (+ n 1))
(define (sum-cubes a b)
  (sum cube a inc b))
(sum-cubes 1 100000)

