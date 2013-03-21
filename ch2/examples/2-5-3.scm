(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

;; self defined
(define (make-poly var iterms) (cons var items))
(define (variable p) (car p))
(define (term-list p) (cdr p))

(define (add-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
		 (add-terms (term-list p1)
			    (term-list p2)))
      (error "Polys not in same var -- ADD-POLY"
	     (list p1 p2))))

(define (mul-poly p1 p2)
  (if (same-variable? (variable p1) (variable p2))
      (make-poly (variable p1)
		 (mul-terms (term-list p1)
			    (term-list p2)))
      (error "Polys not in same var -- MUL-POLY"
	     (list p1 p2))))

(define (attach-tag t cont) (cons t cont))  ;; defined in ch2.4.3
(define get 2d-get)  ;; from ex2.73
(define put 2d-put!)  ;; from ex2.73


(define (install-polynomialpackage)
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  ;; representation of terms and term lists
  ;; adjoin-term
  ;; coeff

  (define (add-poly p1 p2) ...)
  (define (mul-poly p1 p2) ...)

  (define (tag p) (attach-tag 'polynomial p))

  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)

