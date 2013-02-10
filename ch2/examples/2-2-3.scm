(define (sum-odd-squares tree)
  (cond ((null? tree) 0)
	((not (pair? tree))
	 (if (odd? tree) (square tree) 0))
	(else (+ (sum-odd-squares (car tree))
		 (sum-odd-squares (cdr tree))))))

(define (even-fibs n)
  (define (next k)
    (if (> k n)
	 '()
	 (let ((f (fib k)))
	   (if (even? f)
	       (cons f (next (+ k 1)))
	       (next (+ k 1))))))
  (next 0))

;; Sequence Operations
(map square (list 1 2 3 4 5))

;; filter
(define (filter predicate sequence)
  (cond ((null? sequence) '())
	((predicate (car sequence))
	 (cons (car sequence) (filter predicate (cdr sequence))))
	(else (filter predicate (cdr sequence)))))

;; example
(filter odd? (list 1 2 3 4 5))

;; accumulator
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence)
	  (accumulate op initial (cdr sequence)))))

;; example
(accumulate + 0 (list 1 2 3 4 5))
(accumulate * 1 (list 1 2 3 4 5))
(accumulate cons '() (list 1 2 3 4 5))

;; enumerator (interval)
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

;; example
(enumerate-interval 2 7)

;; enumerator (tree)
(define (enumerate-tree tree)
  (cond ((null? tree) '())
	((not (pair? tree)) (list tree))
	(else (append (enumerate-tree (car tree))
		      (enumerate-tree (cdr tree))))))

;; example
(enumerate-tree (list 1 (list 2 (list 3 4)) 5))

(define (sum-odd-squares tree)
  (accumurate + 0 (map square
		       (filter odd? (enumerate-tree tree)))))

(define (even-fibs n)
  (accumulate cons
	      '()
	      (filter even?
		      (map fib (enumerate-interval 0 n)))))

(define (list-fib-squares n)
  (accumulate cons
	      '()
	      (map square
		   (map fib
			(enumerate-interval 0 n)))))

(define (fib n)
  (cond ((= 0 n) 0)
	((= 1 n) 1)
	(else (+ (fib (- n 2)) (fib (- n 1))))))

(list-fib-squares 10)

(define (product-of-squares-of-odd-elements sequence)
  (accumulate *
	      1
	      (map square
		   (filter odd? sequence))))

(product-of-squares-of-odd-elements (list 1 2 3 4 5))
;; 225

(define (salary-of-highest-paid-programmer records)
  (accumulate max
	      0
	      (map salary
		   (filter programer? records))))


;;
;; Nested Mappings
;;

;; (accumulate append
;; 	    '()
;; 	    (map (lambda (i)
;; 		   (map (lambda (j) (list i j))
;; 			(enumerate-interval 1 (- i 1))))
;; 		 (enumerate-interval 1 n)))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum?
	       (flatmap
		(lambda (i)
		  (map (lambda (j) (list i j))
		       (enumerate-interval 1 (- i 1))))
		(enumerate-interval 1 n)))))

(define (permutations s)
  (if (null? s)
      (list '())
      (flatmap (lambda (x)
		 (map (lambda (p) (cons x p))
		      (permutations (remove x s))))
	       s)))

;; support procedure for permutations
(define (remove item sequence)
  (filter (lambda (x) (not (= x item)))
	  sequence))
;; TEST
(remove 3 (list 1 2 3 4 5))
(permutations '(1 2 3))
(permutations '(1 2 3 4 5))


