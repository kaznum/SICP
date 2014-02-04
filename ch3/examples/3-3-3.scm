(define (lookup key table)
  (let ((record (assoc key (cdr table))))
    (if record
	(cdr record)
	false)))

(define (assoc key records)
  (cond ((null? records) false)
	((equal? key (caar records)) (car records))
	(else (assoc key (cdr records)))))

(define (insert! key value table)
  (let ((record (assoc key (cdr table))))
    (if record
	(set-cdr! record value)
	(set-cdr! table
		  (cons (cons key value) (cdr table)))))
  'ok)

(define (make-table)
  (list '*table*))

;; (define onedim (make-table))
;; (insert! 'a 1 onedim)
;; (insert! 'b 2 onedim)
;; (insert! 'c 3 onedim)

;; onedim

;; (lookup 'a onedim)
;; (lookup 'b onedim)
;; (lookup 'c onedim)

;;; Two-dimensional tables

; to be continued
