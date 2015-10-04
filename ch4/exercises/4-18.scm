(define (solve f y0 dt)
  (define y (integral (delay dy) y0 dt))
  (define dy (stream-map f y))
  y)

;; converter in ex4.18
(lambda <vars>
  (let ((u '*unassigned*) (v '*unassigned*))
    (let ((a <e1>) (b <e2>))
      (set! u a)
      (set! v b))
    <e3>))

;; converter in the text
(lambda <vars>
  (let ((u '*unassigned*) (v '*unassigned*))
    (set! u <e1>)
    (set! v <e2>)
    <e3>))

;; Translated with ex4.18's converter
(lambda (f y0 dt)
  (let ((y '*unassigned*) (dy '*unassigned*))
    (let ((a (integral (delay dy) y0 dt))
	  (b (stream-map f y)))
      (set! y a)
      (set! dy b))
    y))

;; and (let ...) is converted again,
(lambda (f y0 dt)
  ((lambda (y dy)
     ((lambda (a b)
	(set! y a)
	(set! dy b))
      (integral (delay dy) y0 dt)
      (stream-map f y)))
   '*unassigned* '*unassigned*))

;; Translated with the text's converter
(lambda (f y0 dt)
  (let ((y '*unassigned*) (dy '*unassigned*))
    (set! y (integral (delay dy) y0 dt))
    (set! dy (stream-map f y))
    y))

;; and (let ...) is converted again,
(lambda (f y0 dt)
  ((lambda (y dy)
     (set! y (integral (delay dy) y0 dt))
     (set! dy (stream-map f y))
     y)
   '*unassigned* '*unassigned*))


;; The case of ex4.18 does not work well because
;; dy is still '*unassigned when (integral...) is evaluated and the result is required,
;; which occurs before (set! dy ...) is called.
;;
;; Otherwise, the case of the text works well because y and dy are set
;; when (integral...) is evaluated.
