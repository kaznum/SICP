(define (negate x) (apply-generic 'negate x))

(define (install-scheme-number-package)
  ;; ...
  (put 'negate 'scheme-number
       (lambda (x) (tag (- x)))))

(define (install-rational-package)
  ;;...
  (put 'negate 'rational
       (lambda (x) (make-rational (- (numer x)) (denom x)))))

(define (install-complex-package)
  ;;...
  (put 'negate 'complex
       (lambda (x) (make-from-real-imag (- (real-part x)) (- (imag-part x))))))


(define (install-polynomial-pakcage)
  (define (negate-terms terms)
    (if (empty-termlist? terms)
	(the-empty-list)
	(let ((term (first-term terms)))
	  (adjoin-term (make-term (order term) (negate (coeff term)))
		       (negate-terms (rest-terms terms))))))

  (put 'negate 'polynomial
       (lambda (p) (make-polynomial (order p) (negate-terms (term-list p)))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (add p1 (negate p2))))))

