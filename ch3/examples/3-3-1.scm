(define x '((a b) c d))
(define y '(e f))
(set-car! x y)
x

(define x '((a b) c d))
(define y '(e f))
(define z (cons y (cdr x)))
z

(define x '((a b) c d))
(define y '(e f))

(set-cdr! x y)
x

(define (cons2 x y)
  (let ((new (get-new-pair)))
    (set-car! new x)
    (set-cdr! new y)
    new))

;; Sharing and Identity

