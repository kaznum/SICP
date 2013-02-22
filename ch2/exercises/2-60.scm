;; no change from unique list
(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
      (cons x set))

(define (union-set set1 set2)
  (append set1 set2))

(define (intersection-set set1 set2)
  (define (remove-first x set)
    (cond ((null? set) '())
	  ((equal? (car set) x) (cdr set))
	  (else (adjoin-set (car set)
			    (remove-first x (cdr set))))))
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (adjoin-set (car set1)
		     (intersection-set (cdr set1)
				       (remove-first (car set1) set2))))
	(else  (intersection-set (cdr set1) set2))))

;; TEST
(intersection-set '(1 2 3 4 5) '(3 4 5 6 7))
(intersection-set '(1 2 5 2 2 3 4 5) '(5 4 3 4 5 2 6 7))

;; The efficiency is 
;; element-of-set?: uniq: [theta](n)   dup: [theta](n)
;; adjoin-set:      uniq: [theta](n)   dup: [theta](1)
;; union-set:       uniq: [theta](n^2) dup: [theta](n)
;; intersection-set uniq: [theta](n^2) dup: [theta](n^2)

;; The duplicate representation is better for the process
;; which needs to call adjoin-set and union-set many times.

