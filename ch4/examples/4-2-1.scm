(define (try a b) (if (= a 0) 1 b))

;; The following generates an error
;; (try 0 (/ 1 0))

(define (unless condition usual-value exceptional-value)
  (if condition exceptional-value usual-value))

;; The follwing expressions generate an error
;; (define a 10)
;; (define b 0)
;; (unless (= b 0)
;; 	(/ a b)
;; 	(begin (display "exception: returning 0") 0))

