(define (make-table same-key?)
  (define (assoc key records)
    (cond ((null? records) false)
	  ((same-key? key (caar records)) (car records))
	  (else (assoc key (cdr records)))))
  (let ((local-table (list '*table*)))
    (define (lookup keys)
      (define (iter ks value)
	(if value
	    (if (null? ks)
		(cdr value)
		(iter (cdr ks) (assoc (car ks) (cdr value))))
	    false))
      (iter keys local-table))

    (define (insert! keys value)
      (define (iter ks table)
	(let* ((key (car ks))
	       (v (assoc key (cdr table))))
	  (if v
	      (if (null? (cdr ks))
		  (set-cdr! v value)
		  (iter (cdr ks) v))
	      (if (null? (cdr ks))
		  (set-cdr! table (cons (cons key value) (cdr table)))
		  (let ((new-table (cons key '())))
		    (set-cdr! table (cons new-table (cdr table)))
		    (iter (cdr ks) new-table))))))
      (iter keys local-table)
      'ok)

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
	    ((eq? m 'insert-proc!) insert!)
	    (else (error "Unknown operation -- TABLE" m))))
    dispatch))

;; TEST
;; double dimension
(define operation-table (make-table (lambda (x y) (equal? x y))))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(put '(sub1 a) 1)
(put '(sub1 b) 2)
(put '(sub2 c) 1)
(put '(sub2 d) 2)

(get '(sub1 a))
;;1
(get '(sub2 d))
;;2
(get '(sub1 c))
;;#f

;; triple dimension
(define triple-table (make-table (lambda (x y) (equal? x y))))
(define get (triple-table 'lookup-proc))
(define put (triple-table 'insert-proc!))

(put '(sub1 a x) 1)
(put '(sub1 b y) 2)
(put '(sub2 c z) 1)
(put '(sub2 d p) 2)

(get '(sub1 a x))
;;1
(get '(sub2 d p))
;;2
(get '(sub2 c x))
;;#f
