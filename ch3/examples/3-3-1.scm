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

(define x (list 'a 'b))

(define z1 (cons x x))
z1

(define z2 (cons (list 'a 'b) (list 'a 'b)))
z2

(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)

z1
;; ((a b) a b)

(set-to-wow! z1)
;; ((wow b) wow b)

z2
;; ((a b) a b)
(set-to-wow! z2)
;; ((wow b) a b)

;; Mutation is just assignment

;; to be continued

