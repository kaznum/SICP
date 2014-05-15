;; ex4-30 a.

(define (for-each proc items)
  (if (null? items)
      'done
      (begin (proc (car items))
	     (for-each proc (cdr items)))))

(for-each (lambda (x) (newline) (display x))
	  (list 57 321 88))
;; Ben is right because  both 'newline' and 'display' are primitive.
;; 1. for-each is evaluated
;; 2. (lambda (x) (newline) (display x)) and (list 57 321 88) become thunk.
;; 3. During for-each evaluation, items which is (list 57 321 88) is forced
;;    because null? is primitive, and (null? items) is evaluated as false.
;; 4. Next, in 'begin' in for-each evaluation, 'proc' which is the thunk
;;    (lambda (x) (newline) (display x)) is forced because operator is always
;;    forced in 'apply', but (cdr items) become thunk.
;; 5. In (proc (car items)), 'car' is primitive, then evaluated as 57.
;; 6. 'newline' and 'display' are  primitive functions then they are forced and display a blank line and '57'
;; 7. (for-each proc (cdr items)) in the next sequence become thunk at first but 'eval' force it soon and loop from 1.

;; ex4-30 b.

(define (p1 x)
  (set! x (cons x '(2)))
  x)
(define (p2 x)
  (define (p e)
    e
    x)
  (p (set! x (cons x '(2)))))

;;;;; with Text's eval-sequence
(p1 1)
;; set! and cons are primitive, then
;; -> (set! x '(1 2))
;; -> x ;; '(1 2)

(p2 1)
;; p is evaluated and
;; (set! x (cons x '(2))) becomes thunk because p is combined procedure.
;; (eval e) is called during the process of (p e) and lookup-variable-value returns '(thunk (set! x (cons x '(2))) env) which is not forced.
;; finary return x as 1 which is the initial argument of (p2 1)


;;;;; with Cy's eval-sequence
(p1 1)
;; The first exp (set! x (cons x '(2))) is forced, then x become '(1 2) .
;; next exp 'x' is evaluated as '(1 2) and return '(1 2)

(p2 1)
;; At the exp (p (set! x (cons x '(2))))), p is forced, and  (set! x (cons x '(2)))) becomes thunk.
;; In the p's process, the first e which is (set! x (cons x '(2))) is forced because Cy's version calls 'actual-value' and x becomes '(1 2)
;; and last x returns '(1 2)


;; ex4-30 c.
;; (lambda (x) (newline) (display x)) is composed with only primitive functions,
;; then they are not delayed even with the text version.


;; ex4-30 d.
;; I think Cy's is better, because it is unpredictable whether expressions are forced or delayed only when reading the partial codes, and it is not desirable to have to think whether the focusing function is primitive or not.

