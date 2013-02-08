;; Given
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (accumulate op initial (cdr sequence)))))

(accumulate + 0 (list 1 2 3 ))
(accumulate cons '() (list 1 2 3 ))

;; Answer
(define (map p sequence)
  (accumulate (lambda (x y) (cons (p x) y)) '() sequence))
;; TEST
(map (lambda (x) (* x 2)) (list 1 2 3 ))

;; Answer
(define (append seq1 seq2)
  (accumulate cons seq2 seq1))

;; TEST
(append (list 1 2 3) (list 4 5 6))

;; Answer
(define (length sequence)
  (accumulate (lambda (x y) (+ 1 y)) 0 sequence))

;; TEST
(length (list 1 2 3))
(length (list 1 2 2 2 2))

