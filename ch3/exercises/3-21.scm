(define (front-ptr queue) (car queue))
(define (rear-ptr queue) (cdr queue))
(define (set-front-ptr! queue item) (set-car! queue item))
(define (set-rear-ptr! queue item) (set-cdr! queue item))
(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (cons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (car (front-ptr queue))))

(define (insert-queue! queue item)
  (let ((new-pair (cons item '())))
    (cond ((empty-queue? queue)
	   (set-front-ptr! queue new-pair)
	   (set-rear-ptr! queue new-pair)
	   queue)
	  (else
	   (set-cdr! (rear-ptr queue) new-pair)
	   (set-rear-ptr! queue new-pair)
	   queue))))

(define (delete-queue! queue)
  (cond ((empty-queue? queue)
	 (error "DELETE! called with an empty queue" queue))
	(else
	 (set-front-ptr! queue (cdr (front-ptr queue)))
	 queue)))

;; 1 ]=> (define q1 (make-queue))
;; ;Value: q1
;; 1 ]=> (insert-queue! q1 'a)
;; ;Value 2: ((a) a)
;; 1 ]=> (insert-queue! q1 'b)
;; ;Value 2: ((a b) b)
;; 1 ]=> (delete-queue! q1)
;; ;Value 2: ((b) b)
;; 1 ]=> (delete-queue! q1)
;; ;Value 2: (() b)


;;; Answer
;; When the 'car' of the queue directs the first entity's pointer of a list, this means the 'car' is taken as the list, so
;; all elements are printed as 'car' and the last element is printed again as cdr.
;; The 'cdr' of the queue is the pointer to the pair of the last entity and nil, but Popping and deleting a queue doesn't
;; change this 'cdr' value so, even if all of the entries in the queue are deleted, the 'cdr' points the element which
;; has been inserted last time.

(define (print-queue queue)
  (display (car queue)))

(define q1 (make-queue))
(insert-queue! q1 'a)
(print-queue q1)
(insert-queue! q1 'b)
(print-queue q1)
(delete-queue! q1)
(print-queue q1)
(delete-queue! q1)
(print-queue q1)

