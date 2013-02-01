(define (make-interval a b) (cons a b))

(define (upper-bound x) (max (car x) (cdr x)))
(define (lower-bound x) (min (car x) (cdr x)))

(define interval (make-interval 3 5))

;; TEST
(upper-bound interval)
(lower-bound interval)
