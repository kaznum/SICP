(lambda <vars>
  (define u <e1>)
  (define u <e2>)
  <e3>)

;;         +----------------------------+
;;         |                            |
;; global  | <anonymous>                |
;;         |    |                       |
;;         +----|-----------------------+
;;              |
;;              V
;;          +-------------------------+
;;      E1  | u : result of <e1>      |
;;          | v : result of <e2>      |
;;          | return : result of <e3> |
;;          +-------------------------+
;;              ^ lambda (vars)
;;              |
;;              |
;;          +--------+
;;      E2  | <e3>   |
;;          +--------+

(lambda <vars>
  (let ((u '*unassigned*)
	(v '*unassigned*))
    (set! u <e1>)
    (set! v <e2>)
    <e3>))

;;         +----------------------------+
;;         |                            |
;; global  | <anonymous>                |
;;         |    |                       |
;;         +----|-----------------------+
;;              |
;;              V
;;          +---------------------------------+
;;      E1  | return: result of (let ...)     |
;;          +---------------------------------+
;;              ^ lambda (<vars>)...
;;              |
;;              | (let ....)
;;          +---------------------------------------------------+
;;      E2  | u: '*unassigned* -> result of <e1>                | ## extra frame
;;          | v: '*unassigned* -> result of <e2>                |    created by (let..
;;          | return: result of <e3>                            |
;;          +---------------------------------------------------+
;;              ^                   ^                 ^  ^  ^
;;              |                   |                 |  |  |
;;              |                   |                 |  |  |
;;          +---------------+     +---------------+   |  |  |
;;      E2  | '*unassigned* |  E3 | '*unassigned* |   |  |  |
;;          +---------------+     +---------------+   |  |  |
;;                                        +-----------+  |  +----------+
;;                                        |              |             |
;;                                        |              |             |
;;                                   +--------+      +--------+      +--------+
;;                               E4  | <e1>   |   E5 | <e2>   |   E6 | <e3>   |
;;                                   +--------+      +--------+      +--------+
;;                                   (set! u ...)    (set! v ...)


;; a. Why is there an extra frame in the transformed program
;;
;; 'define' set the variable directrily in the frame but let creates the frame
;; because 'let' behaves like (lambda..)

;; b. Why this difference in environment structure can never make a difference
;;
;; The case of using 'let' does not change the outer structure of
;; 'let' (in (lambda ...)) and returns only the result to it, which
;; becomes the result of the (lambda ...) too because
;; there is not any other evaluation in (lambda...).
;; The both cases do not make any effect to the global environment and
;; offers the same result.

;; c. Design a way to make the interpreter implement the “simultaneous”
;;    scope rule for internal definitions without constructing the
;;    extra frame.
;;
;; Make all definitions in procedure appear in front of its body.

;; to be continued


