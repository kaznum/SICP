;;; queue format (cons front-entry rear-entry)
;;; each entries's format is '(a *prev *next)
;;; ex: the front item in the queue is (a '() *next)
;;;     the rear item in the queue is (a *prev '())
;;;


(define nil '())
(define (make-deque) (cons nil nil))
(define (update-deque! queue prev next)
  (set-car! queue prev)
  (set-cdr! queue next))
(define (front-deque queue) (car queue))
(define (rear-deque queue) (cdr queue))
(define (new-entry x) (cons x (cons nil nil)))
(define (ptrs entry) (cdr entry))
(define (get-data entry) (car entry))
(define (prev-ptr entry) (car (ptrs entry)))
(define (next-ptr entry) (cdr (ptrs entry)))
(define (set-prev-ptr! current prev)
  (set-car! (ptrs current) prev))
(define (set-next-ptr! current next)
  (set-cdr! (ptrs current) next))

(define (empty-deque? queue)
  (null? (front-deque queue)))

(define (front-insert-deque! queue item)
  (let ((entry (new-entry item)))
    (cond ((empty-deque? queue)
	   (update-deque! queue entry entry))
	  (else
	   (set-next-ptr! entry (front-deque queue))
	   (set-prev-ptr! (front-deque queue) entry)
	   (update-deque! queue entry (rear-deque queue)))))))

(define (rear-insert-deque! queue item)
  (let ((entry (new-entry item)))
    (cond ((empty-deque? queue)
	   (update-deque! queue entry entry))
	  (else
	   (set-prev-ptr! entry (rear-deque queue))
	   (set-next-ptr! (rear-deque queue) entry)
	   (update-deque! queue (front-deque queue) entry)))))

(define (front-delete-deque! queue)
  (cond ((empty-deque? queue)
	 (error "no queue"))
	(else
	 (let ((new-front (next-ptr (front-deque queue))))
	   (cond ((null? new-front)
		  (update-deque! queue nil nil))
		 (else
		  (set-prev-ptr! new-front nil)
		  (update-deque! queue new-front (rear-deque queue)))))))))

(define (rear-delete-deque! queue)
  (cond ((empty-deque? queue)
	 (error "no queue"))
	(else
	 (let ((new-rear (prev-ptr (rear-deque queue))))
	   (cond ((null? new-rear)
		  (update-deque! queue nil nil))
		 (else
		  (set-next-ptr! new-rear nil)
		  (update-deque! queue (front-deque queue) new-rear))))))))

(define (print-deque queue)
  (define (iter entry)
    (cond ((null? entry)
	   (newline))
	  (else
	   (display (get-data entry))
	   (newline)
	   (iter (next-ptr entry)))))
  (iter (front-deque queue)))


;; 1 ]=> (define q1 (make-deque))
;; ;Value: q1
;; 1 ]=> (front-insert-deque! q1 'a)
;; 1 ]=> (print-deque q1)
;; a
;; 1 ]=> (front-insert-deque! q1 'b)
;; 1 ]=> (print-deque q1)
;; ba
;; 1 ]=> (rear-insert-deque! q1 'x)
;; 1 ]=> (print-deque q1)
;; bax
;; 1 ]=> (rear-insert-deque! q1 'y)
;; 1 ]=> (print-deque q1)
;; baxy
;; 1 ]=> (front-delete-deque! q1)
;; 1 ]=> (print-deque q1)
;; axy
;; 1 ]=> (rear-delete-deque! q1)
;; 1 ]=> (print-deque q1)
;; ax
;; 1 ]=> (rear-insert-deque! q1 'p)
;; 1 ]=> (print-deque q1)
;; axp
;; 1 ]=> (front-delete-deque! q1)
;; 1 ]=> (print-deque q1)
;; xp
;; 1 ]=> (front-delete-deque! q1)
;; 1 ]=> (print-deque q1)
;; p
;; 1 ]=> (front-delete-deque! q1)
;; 1 ]=> (print-deque q1)
