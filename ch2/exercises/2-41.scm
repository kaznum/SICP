;; Given
(define (filter predicate sequence)
  (cond ((null? sequence) nil)
	((predicate (car sequence))
	 (cons (car sequence)
	       (filter predicate (cdr sequence))))
	(else (filter predicate (cdr sequence)))))

(define accumulate fold-right)
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

;;
;; Answer
;;
(define (unique-pairs n)
  (flatmap
   (lambda (i)
     (map (lambda (j) (list i j))
	  (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(define (unique-triples n)
  (flatmap
   (lambda (l)
     (map (lambda (k) (cons k l))
	  (enumerate-interval (+ (car l) 1) n)))
   (unique-pairs n)))

(define (sum_all_equals_to? l s)
  (= s (+ (car l) (car (cdr l)) (car (cdr (cdr l))))))

;; TEST
(sum_all_equals_to? '(1 2 3) 6)
(sum_all_equals_to? '(1 2 3) 4)


(define (ordered-triple-of-sum n s)
  (filter (lambda (n) (sum_all_equals_to? n s)) (unique-triples n)))

;; TEST
(ordered-triple-of-sum 6 11)
