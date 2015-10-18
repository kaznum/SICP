;; When there are definitions as follows,
(define (p x) (+ x 1))
(define (f g x) (g x))

;; and called f like the followings,
(f p 5)

;; then 'p' is evaluated as thunk because it is a parameter,
;; when (g x) in the f's definition is interpreted as
;; (p' x) where p' is the thunk of 'p'.
;; If application is evaluated by 'eval' instead of 'actual-value',
;; it cannot be evaluated because it is thunk.
;; (thunk becomes actual value only by `force-it`)
;; So 'eval' uses 'actual-value' (which calls `force-it`) before passing it to 'apply'.
