(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

;;
;; a
;;
(define (left-branch m)
  (car m))

(define (right-branch m)
  (car (cdr m)))

(define (branch-length b)
  (car b))

(define (branch-structure b)
  (car (cdr b)))

;; TEST
(define mob1 (make-mobile (make-branch 1 4)
			  (make-branch 2 2)))
(define mob2 (make-mobile (make-branch 2 9)
			  (make-branch 3 mob1)))
(left-branch mob1)
(right-branch mob1)
(branch-length (left-branch mob1))
(branch-length (right-branch mob1))
(branch-structure (left-branch mob1))
(branch-structure (right-branch mob1))

(left-branch mob2)
(right-branch mob2)
(branch-length (left-branch mob2))
(branch-length (right-branch mob2))
(branch-structure (left-branch mob2))
(branch-structure (right-branch mob2))


;;
;; b
;;

(define (mobile? m)
  (pair? (car m)))
(define (leaf? b)
  (and (not (mobile? b))
       (not (pair? (branch-structure b)))))

(define (branch-weight b)
  (if (leaf? b)
      (branch-structure b)
      (total-weight (branch-structure b))))

(define (total-weight m)
  (+ (branch-weight (left-branch m)) (branch-weight (right-branch m))))

;; TEST
(define mob1 (make-mobile (make-branch 1 4)
			  (make-branch 2 2)))
(total-weight mob1)
;; 6
(branch-weight (left-branch mob1))
(branch-weight (right-branch mob1))

(define mob2 (make-mobile (make-branch 2 9)
			  (make-branch 3 mob1)))
(total-weight mob2)
(branch-weight (left-branch mob2))
(branch-weight (right-branch mob2))
(left-branch mob2)
(branch-length (right-branch mob2))
(branch-weight (right-branch mob2))

;; 15
(define mob3 (make-mobile (make-branch 4 mob2)
			  (make-branch 10 mob1)))

(total-weight mob3)
(left-branch mob3)
(right-branch mob3)
(branch-length (right-branch mob3))
(branch-weight (right-branch mob3))

(branch-weight (left-branch mob3))
(branch-weight (right-branch mob3))
;; 21

(define mob4 (make-mobile (make-branch 4 mob2)
			  (make-branch 8 mob1)))

(total-weight mob4)
;; 21

;;
;; c
;;
(define (branch-total-length b)
  (if (leaf? b)
      (branch-length b)
      (+ (branch-length b) (total-length (branch-structure b)))))

(define (total-length m)
  (+ (branch-total-length (left-branch m)) (branch-total-length (right-branch m))))

;; TEST
(total-length mob1)
;; 3
(total-length mob2)
;; 8
(total-length mob3)
;; 18


(define (balanced? m)
  (let ((lb (left-branch m))
	(rb (right-branch m)))
    (and (= (* (branch-weight lb) (branch-length lb))
	    (* (branch-weight rb) (branch-length rb)))
	 (if (leaf? lb) true (balanced? (branch-structure lb)))
	 (if (leaf? rb) true (balanced? (branch-structure rb))))))

;; TEST
(balanced? mob1)
;; #t
(balanced? mob2)
;; #t
(balanced? mob3)
;; #t
(balanced? mob4)
;; #f


;;
;; d
;;

;; GIVEN
(define (make-mobile left right)
  (cons left right))

(define (make-branch length structure)
  (cons length structure))

;; only two procedures have to be redefined
(define (right-branch m) (cdr m))
(define (branch-structure b) (cdr b))


;; TEST
(define mob1 (make-mobile (make-branch 1 4)
			  (make-branch 2 2)))
(define mob2 (make-mobile (make-branch 2 9)
			  (make-branch 3 mob1)))
(define mob3 (make-mobile (make-branch 4 mob2)
			  (make-branch 10 mob1)))
(define mob4 (make-mobile (make-branch 4 mob2)
			  (make-branch 8 mob1)))

(balanced? mob1)
;; #t
(balanced? mob2)
;; #t
(balanced? mob3)
;; #t
(balanced? mob4)
;; #f
