;; Given
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (accumulate op initial (cdr sequence)))))

(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      '()
      (cons (accumulate op init (map car seqs))
	    (accumulate-n op init (map cdr seqs)))))

(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(dot-product (list 1 2 3) (list 3 4 5))

;; Answer
(define (matrix-*-vector m v)
  (map (lambda (x) (dot-product x v)) m))

;; TEST
(matrix-*-vector (list (list 1 2 3) (list 4 5 6) (list 7 8 9)) (list 1 2 3))
;; (14 32 50)

;; Answer
(define (transpose mat)
  (accumulate-n (lambda (x y) (cons x y)) '() mat))
;; TEST
(transpose (list (list 1 2 3) (list 4 5 6) (list 7 8 9)))

;; Answer
(define (matrix-*-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (x) (matrix-*-vector cols x)) m)))

;; TEST
(matrix-*-matrix '((1 2 3) (4 5 6) (7 8 9))
		 '((1 2 3) (4 5 6) (7 8 9)))




