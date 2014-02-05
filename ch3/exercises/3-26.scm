;; table : '((key subtables) ....)
;; record: '((key value) left-tree right-tree)

(define (make-table compare)
  (define (record-key tree) (caar tree))
  (define (record-value tree) (cdar tree))
  (define (left-records tree) (cadr tree))
  (define (right-records tree) (cddr tree))
  
  (define (assoc-table key tables)
    (cond ((null? tables) false)
	  ((= 0 (compare key (caar tables))) (car tables))
	  (else (assoc-table key (cdr tables)))))
  (define (assoc-record k t)
    (cond ((null? t) false)
	  ((= 0 (compare (record-key t) k)) t)
	  ((< 0 (compare (record-key t) k)) (assoc-record k (right-records t)))
	  ((> 0 (compare (record-key t) k)) (assoc-record k (left-records t)))))
  (let ((local-table (list '*table*)))
    (define (lookup keys)
      (define (iter ks v)
	(if v
	    (if (= 1 (length ks))
		(let ((result (assoc-record (car ks) (cdr v))))
		  (if result
		      (record-value result)
		      false))
		(iter (cdr ks) (assoc-table (car ks) (cdr v))))
	    false))
      (iter keys local-table))

    (define (insert! keys value)
      (define (make-record k v left right)
	(cons (cons k v) (cons left right)))
      
      (define (construct-records k tree)
	(if (null? tree)
	    (make-record k value '() '())
	    (cond ((= 0 (compare k (record-key tree)))
		   (make-record k value
				(left-records tree) (right-records tree)))
		  ((< 0 (compare k (record-key tree)))
		   (make-record (record-key tree) (record-value tree)
				(construct-records k (left-records tree))
				(right-records tree)))
		  ((> 0 (compare k (record-key tree)))
		   (make-record (record-key tree) (record-value tree)
				(left-records tree)
				(construct-records k (right-records tree)))))))
			    
      (define (find-or-create-associated-table key t)
	(let ((associated (assoc-table key (cdr t))))
	  (if associated
	      associated
	      (let ((new-entry (cons key '())))
		(set-cdr! t (cons new-entry (cdr t)))
		new-entry))))

		    
      (define (iter ks t)
	(if (= 1 (length ks))
	    (set-cdr! t (construct-records (car ks) (cdr t)))
	    (iter (cdr ks) (find-or-create-associated-table (car ks) t))))
      (iter keys local-table))

    (define (dispatch m)
      (cond ((eq? m 'lookup-proc) lookup)
	    ((eq? m 'insert-proc!) insert!)
	    (else (error "Unknown operation -- TABLE" m))))
    dispatch))

;; TEST
;; double dimension
(define operation-table (make-table (lambda (x y)
				      (let ((strX (symbol->string x))
					    (strY (symbol->string y)))
					(cond ((string=? strX strY) 0)
					      ((string<? strX strY) -1)
					      ((string>? strX strY) 1))))))

(define get (operation-table 'lookup-proc))
(define put (operation-table 'insert-proc!))

(put '(sub1 a) 1)
(put '(sub1 b) 2)
(put '(sub2 c) 3)
(put '(sub2 d) 4)

(get '(sub1 a))
;;1
(get '(sub2 d))
;;4
(get '(sub1 c))
;;#f

;; triple dimension
(define triple-table (make-table (lambda (x y)
				   (let ((strX (symbol->string x))
					 (strY (symbol->string y)))
				     (cond ((string=? strX strY) 0)
					   ((string<? strX strY) -1)
					   ((string>? strX strY) 1))))))
(define get (triple-table 'lookup-proc))
(define put (triple-table 'insert-proc!))

(put '(sub1 a x) 1)
(put '(sub1 b y) 2)
(put '(sub2 c z) 3)
(put '(sub2 d p) 4)

(get '(sub1 a x))
;;1
(get '(sub2 d p))
;;4
(get '(sub2 c x))
;;#f
;;; update
(put '(sub2 d p) 5)
(get '(sub2 d p))
;;5

