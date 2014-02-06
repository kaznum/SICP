;;; xor = not . and

(define (xor-gate a b output)
  (let ((w (make-wire))
	(x (make-wire))
	(y (make-wire))
	(z (make-wire)))
    (and-gate a b w)
    (inverter w x)
    (or-gate a b y)
    (and-gate x y z)))
;; 1 * (max and-delay or-delay)
;; + 1 * and-delay
;; + 1 * inverter-delay
;; + 1 * or-delay

(define (add-two-bits a b carryover sum)
  (and-gate a b carryover)
  (xor-gate a b sum))
;; 1 * (max and-delay xor-delay)
;; -> 1 * xor-delay (because xor-delay has one and-delay and more)


(define (full-adder c a b sum carryover)
  (let ((o (make-wire))
	(p (make-wire))
	(q (make-wire)))
    (add-two-bits a b o p)
    (add-two-bits c p q sum)
    ;; carry over just for three bits addition
    ;;  (which does not need to call 'add-two-bits')
    (or-gate o q carryover)))
;; 2 * xor-delay + 1 or-delay

(define (ripple-carry-adder as bs ss c)
  (let ((c-in (make-wire)))
    (if (null? as)
	(set-signal! c-in 0)
	(ripple-carry-adder (cdr as) (cdr bs) (cdr ss) c))
    (full-adder c-in (car as) (car bs) (car ss) c)))

;; full-adder is called n times
;; The delay is
;; n * (2 * xor-delay + 1 or-delay)
;; -> n *
;; (2 * (max and-delay or-delay)
;;  + 2 * and-delay
;;  + 2 * inverter-delay
;;  + 3 * or-delay)

;; to be continued
