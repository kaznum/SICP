(define (attach-tag t cont) (cons t cont))  ;; defined in ch2.4.3
(define get 2d-get)  ;; from ex2.73
(define put 2d-put!)  ;; from ex2.73
(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (apply proc (map contents args))
          (apply-each-types args type-tags)))))

(define (install-sparse-polynomial-package)

  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))
  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  (define (the-empty-termlist) '())
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))


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

  ;; the remainings are special for sparse
  (define (first-term term-list) (car term-list))
  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
	term-list
	(cons term term-list)))

  (define (tag p) (attach-tag 'sparse-polynomial p))
  (put 'add '(sparse-polynomial sparse-polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(sparse-polynomial sparse-polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make-sparse 'sparse-polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)

(define (install-dense-polynomial-package)
  ;;..

  ;; the remainings are special for dense
  (define (first-term terms)
    (list (car terms) (- (length terms) 1)))

  (define (adjoin-term term term-list)
    (let ((max-order (- (length term-list) 1)))
      (cond ((= (order term) (+ max-order 1))
	     (cons (coeff term) term-list))
	    ((> (order term) (+ max-order 1))
	     (adjoin-term term (cons 0 term-list)))
	    ((< (order term) (+ max-order 1))
	     (cons (car term-list) (adjoin-term term (cdr term-list)))))))

  (define (tag x) (attach-tag 'dense-polynomial x))
  (put 'add '(dense-polynomial sparse-polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(dense-polynomial dense-polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make-dense 'dense-polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  'done)


(define (add p1 p2) (apply-generic 'add p1 p2))
(define (mul p1 p2) (apply-generic 'mul p1 p2))
(define (make-dense var terms) ((get 'make-dense 'dense-polynomial) var terms))
(define (make-sparse var terms) ((get 'make-sparse 'sparse-polynomial) var terms))

