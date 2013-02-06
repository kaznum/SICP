(define x (list (list 1 2) (list 3 4)))
(define y (list (list 1 2) (list 3 (list 4 5))))

(define (reverse l)
  (if (null? l)
      '()
      (append (reverse (cdr l)) (cons (car l) '()))))

(reverse x)
(reverse y)

(define (deep-reverse l)
  (if (or (not (list? l)) (null? l))
      l
      (append (deep-reverse (cdr l)) (cons (deep-reverse (car l)) '()))))

(deep-reverse x)
(deep-reverse y)
(deep-reverse 1)
