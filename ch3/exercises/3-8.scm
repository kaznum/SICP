(define f (let ((l 0))
	    (lambda (x)
	      (let ((result l))
		(set! l x)
		result))))
;; TEST
(+ (f 0) (f 1))
;; 1
(+ (f 1) (f 0))
;; 0

;; evaluated from right to left in Mit-Scheme
