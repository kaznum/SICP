(define (cont-frac n d k)
  (define (iter i result)
    (cond ((= i 0) result)
	  (else (iter (- i 1) (/ (n i) (+ (d i) result))))))
  (iter k 0))

(define (tan-cf x k)
  (cont-frac (lambda (k) (if (= k 1) x (- (* x x))))
	     (lambda (k) (- (* k 2) 1))
	     k))

(tan-cf 0 10)  ;; tan(0)
(tan-cf (/ 3.14159262 4) 1000)   ;; tan(pi/4) -> =~ 1
(tan-cf (/ 3.14159262 2) 1000)   ;; tan(pi/2) -> infinite number
