;; Given in ex-2.83
(define (raise x) (apply-generic 'raise x))

(put 'raise '(scheme-number)
     (lambda (x) (make-rational x 1)))

(put 'raise '(rational)
     (lambda (x) (make-real (/ (numer x) (denom x)))))

(put 'raise '(real)
     (lambda (x) (make-from-real-img x 0)))


;; Answer
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


