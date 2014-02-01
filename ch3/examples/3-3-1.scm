(define x '((a b) c d))
(define y '(e f))
(set-car! x y)
x
;Value 2: ((e f) c d)

(define x '((a b) c d))
(define y '(e f))
(define z (cons y (cdr x)))
z
;Value 3: ((e f) c d)


(define x '((a b) c d))
(define y '(e f))

(set-cdr! x y)
x
;Value 4: ((a b) e f)

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


(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define z3 z1)
(eq? z1 z2)
;Value: #f
(eq? z1 z3)
;Value: #t
(eq? (car z1) (cdr z1))
;Value: #t
(eq? (car z2) (cdr z2))
;Value: #f

;; Mutation is just assignment

;; to be continued

