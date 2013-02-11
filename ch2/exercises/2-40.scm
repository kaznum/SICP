;; Given
(define accumulate fold-right)
(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (flatmap proc seq)
  (accumulate append '() (map proc seq)))

(define (prime-sum? pair)
  (prime? (+ (car pair) (cadr pair))))

(define (make-pair-sum pair)
  (list (car pair) (cadr pair) (+ (car pair) (cadr pair))))

;;
;; Answer
;;
(define (unique-pairs n)
  (flatmap
   (lambda (i)
     (map (lambda (j) (cons i j))
	  (enumerate-interval 1 (- i 1))))
   (enumerate-interval 1 n)))

(unique-pairs 5)


(define (prime-sum-pairs n)
  (map make-pair-sum
       (filter prime-sum? (unique-pairs n))))
