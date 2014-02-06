;;; (not (and (not a1) (not a2)
;;;              +-----+
;;; a1--[not]-b1-|     |
;;;              | and |-c-[not]-output
;;; a2--[not]-b2-|     |
;;;              +-----+
;;;
(define (or-gate a1 a2 output)
  (let ((b1 (make-wire))
	(b2 (make-wire))
	(c (make-wire)))
    (inverter a1 b1)
    (inverter a2 b2)
    (and-gate b1 b2 c)
    (inverter c output)))

;;; do not need add-action! because all of the wires are
;;; assigned actions to when (or-gate ..) is called, and
;;; since then the signal changes are monitored.

;;; delay is 1 * and-gate-delay + 2 * inverter-delay

