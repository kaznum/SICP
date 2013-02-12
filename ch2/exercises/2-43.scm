;; ex2.42's process
(flatmap
 (lambda (rest-of-queens)
   (map (lambda (new-row)
	  (adjoin-position new-row k rest-of-queens))
	(enumerate-interval 1 board-size)))
 (queen-cols (- k 1)))

;; ex2.43's process
(flatmap
 (lambda (new-row)
   (map (lambda (rest-of-queens)
	  (adjoin-position new-row k rest-of-queens))
	(queen-cols (- k 1))))
 (enumerate-interval 1 board-size))

;; the latter process execute queens-col many times.
;; For example for the 6x6 case, the former one executes filter 7 times (for each k = 0 .. 6),
;; but the latter one executes 7 times * 6 = 42 times.
;; This means the answer is approximately k*T
