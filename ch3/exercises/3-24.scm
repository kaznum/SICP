(define (assoc key records same-key?)
  (cond ((null? records) false)
	((same-key? key (caar records)) (car records))
	(else (assoc key (cdr records) same-key?))))

(define (make-table same-key?)
  (let ((local-table (list '*table*)))
    (define (lookup key-1 key-2)
      (let ((subtable (assoc key-1 (cdr local-table) same-key?)))
    (if subtable
	(let ((record (assoc key-2 (cdr subtable) same-key?)))
	  (if record
	      (cdr record)
	      false))
	false)))

    (define (insert! key-1 key-2 value)
      (let ((subtable (assoc key-1 (cdr local-table) same-key?)))
	(if subtable
	    (let ((record (assoc key-2 (cdr subtable) same-key?)))
	      (if record
		  (set-cdr! record value)
		  (set-cdr! subtable
			    (cons (cons key-2 value)
				  (cdr subtable)))))
	    (set-cdr! local-table
		      (cons (list key-1 (cons key-2 value))
			    (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
	    ((eq? m 'insert-proc!) insert!)
	    (else (error "Unknown operation -- TABLE" m))))
    dispatch))

(define operation-table (make-table (lambda (x y) (equal? x y))))
(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))
(put 'sub1 'a 1)
(put 'sub1 'b 2)
(put 'sub2 'c 1)
(put 'sub2 'd 2)

(get 'sub1 'a)
;; 1
(get 'sub2 'd)
;; 2
(get 'sub1 'c)
;; #f

