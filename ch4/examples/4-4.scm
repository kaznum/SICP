(define (append x y)
  (if (null? x) y (cons (car x) (append (cdr x) y))))

;; If x is null, then (append x y) is y
;; For u, v, y and z, (append v y) is z
;;   Then (append (cons u v) y) is (cons u z)
