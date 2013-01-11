(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
	(else else-clause)))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
	  guess
	  (sqrt-iter (improve guess x)
		     x)))
;;
;; (if predicate ...) uses normal-order evaluation because it is a special-form but (new-if ...) uses the applicative-order evaluation because it is procedure.
;; So, whether the result of '(good-enough? guess x)' is true or false, it evaluate (sqrt-iter (improve guess x) x) in advance, which is led to infinite loop
;;

(define (sqrt x)
  (sqrt-iter 1.0 x))

(sqrt 2)
