;; Given
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc seq)
  (fold-right append '() (map proc seq)))

(define (queens board-size)
  (define (queen-cols k)
    (if (= k 0)
	(list empty-board)
	(filter
	 (lambda (positions) (safe? k positions))
	 (flatmap
	  (lambda (rest-of-queens)
	    (map (lambda (new-row)
		   (adjoin-position new-row k rest-of-queens))
		 (enumerate-interval 1 board-size)))
	  (queen-cols (- k 1))))))
  (queen-cols board-size))

;;
;; Answer
;;
(define empty-board '())
(define (make-pos row col) (list row col))
(define (row pos) (car pos))
(define (col pos) (cadr pos))

;; rest-of-queens is a way to place k - 1 queens
(define (adjoin-position new-row k rest-of-queens)
  (cons (make-pos new-row k) rest-of-queens))

(define (row-of-col k positions)
  (let ((first (car positions)))
    (if (= k (col first))
	(row first)
	(row-of-col k (cdr positions)))))

(define (duplicated? k r positions)
  (fold-right (lambda (x y) (or x y))
	      false
	      (map (lambda (c)
		     (let ((c-row (row-of-col c positions)))
		       (or (= r c-row)
			   (= r (- c-row (- k c)))
			   (= r (+ c-row (- k c))))))
		   (enumerate-interval 1 (- k 1)))))

(define (safe? k positions)
  (not (duplicated? k (row-of-col k positions) positions)))

(queens 4)
(queens 8)
(length (queens 8))

