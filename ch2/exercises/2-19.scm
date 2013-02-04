;; preparation
(define (cc amount coin-values)
  (cond ((= amount 0) 1)
	((or (< amount 0) (no-more? coin-values)) 0)
	(else
	 (+ (cc amount
		(except-first-denomination coin-values))
	    (cc (- amount
		   (first-denomination coin-values))
		coin-values)))))
;;
;; Solution
;;
(define no-more? null?)
(define first-denomination car)
(define except-first-denomination cdr)

;; TEST
(define us-coins (list 50 25 10 5 1))
(define uk-coins (list 100 50 20 10 5 2 1 0.5))

(cc 100 us-coins)
;;292

(define us-coins2 (list 5 25 10 50 1))
(cc 100 us-coins2)
;;292

;; The result does not depend on the order of the elements in coin-values
;; because cc has the patterns to skip some denominations.
