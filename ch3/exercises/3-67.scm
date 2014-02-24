;; from text
(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1)
		   (interleave s2 (stream-cdr s1)))))

;;; Image
;; (i i)   (i   i+1)  ---->    ---->   ----->
;; (i+1,i) (i+1 i+1) (i+1 i+2)
;; (i+2,i)
;;   |
;;   |
;;   V
;; (additional
;;  stream)
;; Answer
(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
   (interleave
    (interleave
     (stream-map (lambda (x) (list (stream-car s) x))
		 (stream-cdr t))
     (stream-map (lambda (x) (list x (stream-car t)))
		 (stream-cdr s)))
    (pairs (stream-cdr s) (stream-cdr t)))))
;; end of answer

(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))

(define integers
  (integers-from 1))

(define (show-stream s n)
  (if (zero? n)
      'done
      (begin
	(newline)
	(display (stream-car s))
	(show-stream (stream-cdr s) (- n 1)))))

;; test
(define int-pairs (pairs integers integers))

(show-stream int-pairs 20)
;; (1 1)
;; (1 2)
;; (2 2)
;; (2 1)
;; (2 3)
;; (1 3)
;; (3 3)
;; (3 1)
;; (3 2)
;; (1 4)
;; (3 4)
;; (4 1)
;; (2 4)
;; (1 5)
;; (4 4)
;; (5 1)
;; (4 2)
;; (1 6)
;; (4 3)
;; (6 1)
