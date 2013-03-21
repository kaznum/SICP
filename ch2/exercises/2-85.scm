(define (project x) (apply-generic 'project x))

(put 'project '(complex)
     (lambda (x) (make-real (real-part x))))

(put 'project '(real)
     (lambda (x)
       (let ((rat (rationalize (inexact->exact x) 1/100)))
	 (make-rational (numerator rat) (denominator rat)))))

(put 'project '(rational)
     (lambda (x) (make-scheme-number (round (/ (numer x) (denom x))))))

(define (drop x)
  (if (eq? (type-tag x) 'scheme-number)
      x
      (let ((projected_val (project x)))
	(if (= (contents x) (contents (raise projected_val)))
	    projected_val
	    (error "cannot drop")))
      (error "cannot drop")))


;; Just apply 'drop' to the returned value
(define (apply-generic op . args)
  (define (find-proc-args op a1 a2)
    (let ((type1 (type-tag a1))
          (type2 (type-tag a2)))
      (let ((proc1 (get op type1 type2))
            (proc2 (get op type2 type1)))
        (cond (proc1 (list proc1 a1 a2))
              (proc2 (list proc2 a2 a1))
              ((get 'raise a1)
               (let ((raised-proc-args (find-proc-args (get'raise a1) a2)))
                 (if raised-proc-args
                     raised-proc-args
                     (find-proc-args a1 (get'raise a2)))))
              (else #f)))))
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
          (drop (apply proc (map contents args)))
          (if (= (length args) 2)
              (let ((a1 (car args))
                    (a2 (cadr args)))
                (let (proc-args (find-proc-args op a1 a2))
                  (if proc-args
                      (drop ((car proc-args) (cadr proc-args) (caddr proc-args)))
                      (error "No method for these types"
                             (list op type-tags)))))
              (error "No method for these types"
                     (list op type-tags)))))))
