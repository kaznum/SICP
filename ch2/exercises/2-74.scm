;; a)
(define (get-record division name)
  ((get division 'record) name))
;; each division file's records have unique employee's name field

;; b)
(define (get-salary division record)
  ((get division 'salary) record))
;; each record set has a salary field


;; c)
(define (find-employee-record name divisions)
  (cond ((null? divisions) false)
	((get-record (car divisions) name) (car divisions))
	(else (find-employee-record name (cdr division)))))

;; d)
;; Create the installer to the lookup table which has the procedures according to
;; 'record, 'salary  only to support the new division's personnel information file format.
