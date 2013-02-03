;; preparation

(define (make-interval a b) (cons a b))
(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))
(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

;;
;; define make-center-percent
;;
(define (make-center-percent a b)
  (let ((w (* a (/ b 100))))
    (make-interval (- a w) (+ a w))))

(define (percent x)
  (* (/ (width x) (center x)) 100))

(define i (make-center-percent 120 10))
(upper-bound i)
(lower-bound i)
(center i)
(percent i)

