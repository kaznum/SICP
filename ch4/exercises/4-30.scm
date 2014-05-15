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

;; ex-30 b.


;; to be continued
