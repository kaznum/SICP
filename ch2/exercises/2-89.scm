(define (install-polynomial-package)
  ;;...
  (define (first-term terms)
    (list (car terms) (- (length terms) 1)))

  (define (adjoin-term term term-list)
    (let ((max-order (- (length term-list) 1)))
      (cond ((= (order term) (+ max-order 1))
	     (cons (coeff term) term-list))
	    ((> (order term) (+ max-order 1))
	     (adjoin-term term (cons 0 term-list)))
	    ((< (order term) (+ max-order 1))
	     (cons (car term-list) (adjoin-term term (cdr term-list))))))))
)





