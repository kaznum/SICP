;;
;; recursive process
;;
(define (cont-frac n d k)
  (define (rec i)
    (if (> i k) 0
	(/ (n i) (+ (d i) (rec (+ i 1))))))
  (rec 1))

(define (golden-ratio k)
  (/ 1
     (cont-frac (lambda (i) 1.0)
		(lambda (i) 1.0)
		k)))

;; the answer should be approximately  
;; 1.618033988749895
(golden-ratio 1)
;; 1.
(golden-ratio 2)
;; 2.
(golden-ratio 6)
;; 1.625
(golden-ratio 8)
;; 1.6190
(golden-ratio 9)
;; 1.6176
(golden-ratio 10)
;; 1.6181
(golden-ratio 11)
;; 1.6179

;; k = 9 for 4 decimal correctness


;;
;; iterative process
;;
(define (cont-frac-iter n d k)
  (define (iter i result)
    (cond ((= i 0) result)
	  (else (iter (- i 1) (/ (n i) (+ (d i) result))))))
  (iter k 0))

(define (golden-ratio-iter k)
  (/ 1
     (cont-frac-iter (lambda (i) 1.0)
		     (lambda (i) 1.0)
		     k)))

(golden-ratio-iter 8)
;; 1.6190
(golden-ratio-iter 9)
;; 1.6176
(golden-ratio-iter 10)
;; 1.6181

