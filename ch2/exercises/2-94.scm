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
  ;; Added in this exerciese
  (put 'greatest-common-divisor '(scheme-number scheme-number)
       (lambda (a b) (gcd a b)))
  (put 'negate '(scheme-number)
       (lambda (x) (- x)))
  'done)

(define (make-scheme-number n)
  ((get 'make 'scheme-number) n))

;; Given in the section 2.5.3 and customise in this exercise
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


  (define (gcd-terms a b)
    (if (empty-termlist? b)
	a
	(gcd-terms b (remainder-terms a b))))

  (define (remainder-terms a b)
    ;;(sub-terms a (mul-terms (div-terms a b) b)))
    (cadr (div-terms a b)))

  (define (div-terms L1 L2)
    (if (empty-termlist? L1)
	(list (the-empty-termlist) (the-empty-termlist))
	(let ((t1 (first-term L1))
	      (t2 (first-term L2)))
	  (if (> (order t2) (order t1))
	      (list (the-empty-termlist) L1)
	      (let ((new-c (div (coeff t1) (coeff t2)))
		    (new-o (- (order t1) (order t2))))
		(let ((rest-of-result
		       (div-terms
			(add-terms L1 (negate-terms (mul-terms L2 (list (make-term new-o new-c))))) L2)))
		  (list (adjoin-term (make-term new-o new-c) (car rest-of-result))
			(cadr rest-of-result))))))))

  (define (div-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(make-poly (variable p1) (div-terms (term-list p1) (term-list p2)))
	(error "not the same variables" (list p1 p2))))


  (define (gcd-poly p1 p2)
    (if (same-variable? (variable p1) (variable p2))
	(make-poly (variable p1)
		   (gcd-terms (term-list p1)
			      (term-list p2)))
	(error "not the same variable - GCD-POLY" (list (variable p1) (variable p2)))))

  (define (negate-terms terms)
    (if (empty-termlist? terms)
        (the-empty-termlist)
        (let ((term (first-term terms)))
          (adjoin-term (make-term (order term) (negate (coeff term)))
                       (negate-terms (rest-terms terms))))))


  (define (tag p) (attach-tag 'polynomial p))
  (put 'negate '(polynomial)
       (lambda (p) (make-polynomial (order p) (negate-terms (term-list p)))))
  (put 'sub '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 (negate p2)))))
  (put 'add '(polynomial polynomial)
       (lambda (p1 p2) (tag (add-poly p1 p2))))
  (put 'mul '(polynomial polynomial)
       (lambda (p1 p2) (tag (mul-poly p1 p2))))
  (put 'div '(polynomial polynomial)
       (lambda (p1 p2) (tag (div-poly p1 p2))))
  (put 'make 'polynomial
       (lambda (var terms) (tag (make-poly var terms))))
  (put '=zero? '(polynomial)
       (lambda (p) (empty-termlist? (term-list p))))
  (put 'greatest-common-divisor '(polynomial polynomial)
       (lambda (p1 p2) (tag (gcd-poly p1 p2))))
  'done)

(define (make-polynomial variable term-list)
  ((get 'make 'polynomial) variable term-list))

(put 'raise 'scheme-number
     (lambda (n) (make-polynomial 'none (list (list 0 n)))))


(define (install-rational-package)
  (define (numer x) (car x))
  (define (denom x) (cdr x))
  (define (make-rat n d)
    (let ((g (greatest-common-divisor n d)))
      (cons (div n g) (div d g))))
  (define (add-rat x y)
    (make-rat (add (mul (numer x) (denom y))
                 (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (sub-rat x y)
    (make-rat (sub (mul (numer x) (denom y))
                 (mul (numer y) (denom x)))
              (mul (denom x) (denom y))))
  (define (mul-rat x y)
    (make-rat (mul (numer x) (numer y))
              (mul (denom x) (denom y))))
  (define (div-rat x y)
    (make-rat (mul (numer x) (denom y))
              (mul (denom x) (numer y))))
  (define (tag x) (attach-tag 'rational x))
  (put 'add '(rational rational)
       (lambda (x y) (tag (add-rat x y))))
  (put 'sub '(rational rational)
       (lambda (x y) (tag (sub-rat x y))))
  (put 'mul '(rational rational)
       (lambda (x y) (tag (mul-rat x y))))
  (put 'div '(rational rational)
       (lambda (x y) (tag (div-rat x y))))
  (put 'make 'rational
       (lambda (n d) (tag (make-rat n d))))
  (put 'negate '(rational)
       (lambda (x) (make-rational (negate (numer x)) (denom x))))
  'done)

(define (make-rational n d)
  ((get 'make 'rational) n d))

;; This exerceise
(install-scheme-number-package)
(install-polynomial-package)
(install-rational-package)

(define (add p1 p2) (apply-generic 'add p1 p2))
(define (mul p1 p2) (apply-generic 'mul p1 p2))
(define (=zero? p1) (apply-generic '=zero? p1))
(define (div p1 p2) (apply-generic 'div p1 p2))
(define (sub p1 p2) (apply-generic 'sub p1 p2))
(define (greatest-common-divisor p1 p2) (apply-generic 'greatest-common-divisor p1 p2))
(define (negate x) (apply-generic 'negate x))

(define p1 (make-polynomial 'x '((4 1) (3 -1) (2 -2) (1 2))))
(define p2 (make-polynomial 'x '((3 1) (1 -1))))
(greatest-common-divisor p1 p2)
;;(polynomial x (2 -1) (1 1))

