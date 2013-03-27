;; defined in ch2.4.3
(define (attach-tag t cont) (cons t cont))


(define (get x-key y-key)
  (let ((1d-table (2d-get-alist-x x-key)))
    (let ((type-f (assoc y-key 1d-table)))
      (if type-f (cdr type-f) false))))
(define put 2d-put!)

(define (contents x)
  (cond ((pair? x) (cdr x))
	((number? x) x)
	(else (error "Not supported" x))))


(define (apply-generic op . args)
  (define (find-proc-args op a1 a2)
    (let ((type1 (type-tag a1))
	  (type2 (type-tag a2)))
      (let ((proc1 (get op (list type1 type2)))
	    (proc2 (get op (list type2 type1))))
	(cond (proc1 (list proc1 a1 a2))
	      (proc2 (list proc2 a2 a1))
	      ((and (get 'raise type1) (get 'raise type2))
	       (or (find-proc-args op ((get 'raise type1) a1) a2) (find-proc-args op a1 ((get 'raise type2) a2))))
	      ((get 'raise type1)
	       (find-proc-args op ((get 'raise type1) a1) a2))
	      ((get 'raise type2)
	       (find-proc-args op a1 ((get 'raise type2) a2)))
	      (else #f)))))
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))
	  (if (= (length args) 2)
	      (let ((a1 (car args))
		    (a2 (cadr args)))
		(let ((proc-args (find-proc-args op a1 a2)))
		  (if proc-args
		      ((car proc-args) (contents (cadr proc-args)) (contents (caddr proc-args)))
		      (error "No method for these types"
			     (list op type-tags)))))
	      (error "No method for these types"
		     (list op type-tags)))))))

(define (type-tag x)
  (cond ((pair? x) (car x))
	((number? x) 'scheme-number)
	(else (error "No type defined - TYPE-TAG" x))))

(define (install-scheme-number-package)
  (define (tag x)
    (attach-tag 'scheme-number x))
  (put 'add '(scheme-number scheme-number)
       (lambda (x y) (+ x y)))
  (put 'sub '(scheme-number scheme-number)
       (lambda (x y) (- x y)))
  (put 'mul '(scheme-number scheme-number)
       (lambda (x y) (* x y)))
  (put 'div '(scheme-number scheme-number)
       (lambda (x y) (/ x y)))
  (put '=zero? '(scheme-number)
       (lambda (x) (= x 0)))
  (put 'make 'scheme-number
       (lambda (x) x))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

;; Given in the section 2.5.3
(define (install-polynomial-package)
  (define (make-poly variable term-list)
    (cons variable term-list))
  (define (variable p) (car p))
  (define (term-list p) (cdr p))

  (define (variable? x) (symbol? x))
  (define (same-variable? v1 v2)
    (and (variable? v1) (variable? v2) (eq? v1 v2)))

  (define (adjoin-term term term-list)
    (if (=zero? (coeff term))
	term-list
	(cons term term-list)))

  (define (the-empty-termlist) '())
  (define (first-term term-list) (car term-list))
  (define (rest-terms term-list) (cdr term-list))
  (define (empty-termlist? term-list) (null? term-list))

  (define (make-term order coeff) (list order coeff))
  (define (order term) (car term))
  (define (coeff term) (cadr term))

  (define (add-terms L1 L2)
    (cond ((empty-termlist? L1) L2)
	  ((empty-termlist? L2) L1)
	  (else
	   (let ((t1 (first-term L1)) (t2 (first-term L2)))
	     (cond ((> (order t1) (order t2))
		    (adjoin-term
		     t1 (add-terms (rest-terms L1) L2)))
		   ((< (order t1) (order t2))
		    (adjoin-term
		     t2 (add-terms L1 (rest-terms L2))))
		   (else
		    (adjoin-term
		     (make-term (order t1)
				(add (coeff t1) (coeff t2)))
		     (add-terms (rest-terms L1)
				(rest-terms L2)))))))))


  (define (mul-terms L1 L2)
    (if (empty-termlist? L1)
	(the-empty-termlist)
	(add-terms (mul-term-by-all-terms (first-term L1) L2)
		   (mul-terms (rest-terms L1) L2))))

  (define (mul-term-by-all-terms t1 L)
    (if (empty-termlist? L)
	(the-empty-termlist)
	(let ((t2 (first-term L)))
	  (adjoin-term
	   (make-term (add (order t1) (order t2))
		      (mul (coeff t1) (coeff t2)))
	   (mul-term-by-all-terms t1 (rest-terms L))))))

  (define (add-poly p1 p2)
    (let ((var1 (variable p1))
	  (var2 (variable p2)))
      (cond ((eq? var1 var2)
	     (make-poly var1
			(add-terms (term-list p1)
				   (term-list p2))))
	    ((eq? var1 'none)
	     (add-poly p2 (make-poly var2 (term-list p1))))
	    ((eq? var2 'none)
	     (add-poly p1 (make-poly var1 (term-list p2))))
	    (else
	     (add-poly p1
		       (make-poly var1
				  (adjoin-term (make-term 0 (tag p2)) (the-empty-termlist))))))))

  (define (mul-poly p1 p2)
    (let ((var1 (variable p1))
	  (var2 (variable p2)))
      (cond ((eq? var1 var2)
	     (make-poly var1
			(mul-terms (term-list p1)
				   (term-list p2))))
	    ((eq? var1 'none)
	     (mul-poly p2 (make-poly var2 (term-list p1))))
	    ((eq? var2 'none)
	     (mul-poly p1 (make-poly var1 (term-list p2))))
	    (else
	     (mul-poly p1
		       (make-poly var1
				  (adjoin-term (make-term 0 (tag p2)) (the-empty-termlist))))))))


  ;; interface to rest of the system
  (define (tag p) (attach-tag 'polynomial p))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put '=zero? '(polynomial)
       (lambda (p) (empty-termlist? (term-list p))))
  'done)

(define (make-polynomial variable term-list)
  ((get 'make 'polynomial) variable term-list))

(put 'raise 'scheme-number
     (lambda (n) (make-polynomial 'none (list (list 0 n)))))

;; TEST
(install-scheme-number-package)
(install-polynomial-package)


(define (add p1 p2) (apply-generic 'add p1 p2))
(define (mul p1 p2) (apply-generic 'mul p1 p2))
(define (=zero? p1) (apply-generic '=zero? p1))

(add 1 2)
(mul 3 2)
(add (make-polynomial 'x '((3 2) (2 1))) (make-polynomial 'x '((5 3) (2 2))))
(add (make-polynomial 'x '((3 2) (2 1))) 3)
(add 3 (make-polynomial 'x '((3 2) (2 1))))
(add (make-polynomial 'x '((3 2) (2 1))) (make-polynomial 'x '((5 3) (2 2))))
(add (make-polynomial 'x '((3 2))) (make-polynomial 'x '((5 3) (3 1))))

(mul (make-polynomial 'x '((3 2) (1 1))) (make-polynomial 'x '((6 3) (2 2))))
(mul (make-polynomial 'x '((3 2) (1 1))) (make-polynomial 'x '((2 3) (0 2))))

(add (make-polynomial 'x '((3 2) (2 1))) (make-polynomial 'y '((5 3) (2 2))))
(add (make-polynomial 'y '((3 2) (2 1))) (make-polynomial 'x '((5 3) (2 2))))
(mul (make-polynomial 'x '((3 2) (1 1))) (make-polynomial 'y '((2 3) (0 2))))
(mul (make-polynomial 'x '((3 2))) (make-polynomial 'y '((2 3))))
(mul 3 (make-polynomial 'x '((2 3) (0 2))))
(mul (make-polynomial 'x '((2 3) (0 2))) 3)


