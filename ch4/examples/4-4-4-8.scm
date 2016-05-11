(define (make-binding variable value)
  (cons variable value))
(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))
(define (binding-in-frame variable frame)
  (assoc variable frame))
(define (extend variable value frame)
  (cons (make-binding variable value) frame))

;;;; TEST assoc
;; 1 ]=> (define x (list (cons 'a 1) (cons 'b 2)))
;; ;Value: x
;; 1 ]=> (assoc 'a x)
;; ;Value 3: (a . 1)
;; 1 ]=> (assoc 'b x)
;; ;Value 4: (b . 2)
;; 1 ]=> (assoc 'c x)
;; ;Value: #f

