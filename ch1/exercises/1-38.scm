(define (cont-frac n d k)
  (define (iter i result)
    (cond ((= i 0) result)
	  (else (iter (- i 1) (/ (n i) (+ (d i) result))))))
  (iter k 0))

(define (e k)
  (+ 2
     (cont-frac (lambda (x) 1.0) (lambda (x) (if (= (remainder x 3) 2)
						 (* 2 (/ (+ x 1) 3))
						 1))
		k)))
(e 1)
;; 3.
(e 2)
;; 2.6666666666666665
(e 10)
;; 2.7182817182817183
(e 100)
;; 2.7182818284590455

;; the number to match
;; e = 2.71828 18284 59045 23536 02874 71352 …
;; (http://ja.wikipedia.org/wiki/%E3%83%8D%E3%82%A4%E3%83%94%E3%82%A2%E6%95%B0)

						 
					      
