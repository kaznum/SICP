(define zero (lambda (f) (lambda (x) x)))
(define (add-1 n)
  (lambda (f) (lambda (x) (f ((n f) x)))))

;; (add-1 zero)'s substitution evaluation
;; (define one (add-1 zero))
;; (define one (add-1 (lambda (f) (lambda (x) x))))
;; (define one (lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x)))))
;; (define one (lambda (f) (lambda (x) (f ((lambda (x) x) x)))))
(define one (lambda (f) (lambda (x) (f x))))

;; (define two (add-1 one))'s substitution evaluation
;; (define two (add-1 one))
;; (define two
;;   (add-1 (lambda (f) (lambda (x) (f x)))))
;; (define two
;;   (lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) (f x))) f) x)))))
;; (define two
;;   (lambda (f) (lambda (x) (f ((lambda (x) (f x)) x)))))
;; (define two
;;   (lambda (f) (lambda (x) (f (f x)))))
(define two (lambda (f) (lambda (x) (f (f x)))))

;; define +
(define zero  (lambda (f) (lambda (x) x)))
(define one   (lambda (f) (lambda (x) (f x))))
(define two   (lambda (f) (lambda (x) (f (f x)))))
(define three (lambda (f) (lambda (x) (f (f (f x))))))
(define four  (lambda (f) (lambda (x) (f (f (f (f x)))))))
(define five  (lambda (f) (lambda (x) (f (f (f (f (f x))))))))


;; example
(five f)
(lambda (x) (f (f (f (f (f x))))))
;; example
((five f) ((two f) x))
(lambda (x) (f (f (f (f (f x))))))  (f (f x))
(f (f (f (f (f (f (f x))))))) ;; seven

;; the answer
(define (plus n v)
  (lambda (f) (lambda (x) ((n f) ((v f) x)))))


