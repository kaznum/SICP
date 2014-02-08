;;; queue management
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

;; segment and agenda management

(define (make-time-segment time queue)
  (cons time queue))
(define (segment-time s) (car s))
(define (segment-queue s) (cdr s))


;;; agenda : (10 . segments)  ... 10 is the current processing segment's time
(define (make-agenda) (list 0))
(define (current-time agenda) (car agenda))

(define (set-current-time! agenda time)
  (set-car! agenda time))

(define (segments agenda) (cdr agenda))

(define (set-segments! agenda segments)
  (set-cdr! agenda segments))

(define (first-segment agenda) (car (segments agenda)))
(define (rest-segments agenda) (cdr (segments agenda)))

(define (empty-agenda? agenda)
  (null? (segments agenda)))

(define (add-to-agenda! time action agenda)
  (define (belongs-before? segments)
    (or (null? segments)
	(< time (segment-time (car segments)))))
  (define (make-new-time-segment time action)
    (let ((q (make-queue)))
      (insert-queue! q action)
      (make-time-segment time q)))
  (define (add-to-segments! segments)
    (if (= (segment-time (car segments)) time)
	(insert-queue! (segment-queue (car segments))
		       action)
	(let ((rest (cdr segments)))
	  (if (belongs-before? rest)
	      (set-cdr! segments
			(cons (make-new-time-segment time action)
			      (cdr segments)))
	      (add-to-segments! rest)))))
  (let ((segments (segments agenda)))
    (if (belongs-before? segments)
	(set-segments!
	 agenda
	 (cons (make-new-time-segment time action)
	       segments))
	(add-to-segments! segments))))

(define (remove-first-agenda-item! agenda)
  (let ((q (segment-queue (first-segment agenda))))
    (delete-queue! q)
    (if (empty-queue? q)
	(set-segments! agenda (rest-segments agenda)))))

(define (first-agenda-item agenda)
  (if (empty-agenda? agenda)
      (error "Agenda is empty -- FIRST-AGENDA-ITEM")
      (let ((first-seg (first-segment agenda)))
	(set-current-time! agenda (segment-time first-seg))
	(front-queue (segment-queue first-seg)))))

;;; wire management

(define (make-wire)
  (let ((signal-value 0) (action-procedures '()))
    (define (set-my-signal! new-value)
      (if (not (= signal-value new-value))
	  (begin (set! signal-value new-value)
		 (call-each action-procedures))
	  'done))
    (define (accept-action-procedure! proc)
      (set! action-procedures (cons proc action-procedures))
      (proc))
    (define (dispatch m)
      (cond ((eq? m 'get-signal) signal-value)
	    ((eq? m 'set-signal!) set-my-signal!)
	    ((eq? m 'add-action!) accept-action-procedure!)
	    (else (error "Unknown operation -- WIRE" m))))
    dispatch))

(define (call-each procedures)
  (if (null? procedures)
      'done
      (begin
	((car procedures))
	(call-each (cdr procedures)))))

(define (get-signal wire)
  (wire 'get-signal))
(define (set-signal! wire new-value)
  ((wire 'set-signal!) new-value))
(define (add-action! wire action-procedure)
  ((wire 'add-action!) action-procedure))

;;; The agenda
(define (after-delay delay action)
  (add-to-agenda! (+ delay (current-time the-agenda))
		  action
		  the-agenda))


(define (propagate)
  (if (empty-agenda? the-agenda)
      'done
      (let ((first-item (first-agenda-item the-agenda)))
	(first-item)
	(remove-first-agenda-item! the-agenda)
	(propagate))))

;;; A sample simuration

(define (probe name wire)
  (add-action! wire
	       (lambda ()
		 (newline)
		 (display name)
		 (display " ")
		 (display (current-time the-agenda))
		 (display " New-value = ")
		 (display (get-signal wire)))))

;;; Primitive function boxes

(define (logical-and a b)
  (and a b))

(define (and-gate a1 a2 output)
  (define (and-action-procedure)
    (let ((new-value
	   (logical-and (get-signal a1) (get-signal a2))))
      (after-delay and-gate-delay
		   (lambda ()
		     (set-signal! output new-value)))))
  (add-action! a1 and-action-procedure)
  (add-action! a2 and-action-procedure)
  'ok)

;;; sample code
;; investigate the-agenda
(define (investigate-agenda)
  (newline)
  (display "time: ")
  (display (current-time the-agenda))
  (newline)
  (display "segments count: ")
  (display (length (segments the-agenda)))
  (newline)
  (display "segments: ")
  (display (segments the-agenda))
  (newline))

(define the-agenda (make-agenda))
(define and-gate-delay 3)

(define input-1 (make-wire))
(define input-2 (make-wire))
(define output-1 (make-wire))
(probe 'output-1 output-1)

(newline)
(display "#############--- (set-signal! input-2 1) ---")
(set-signal! input-2 1)
(investigate-agenda)

(newline)
(display "#############--- (and-gate input-1 input-2 output-1) ---")
(and-gate input-1 input-2 output-1)
(investigate-agenda)

(newline)
(display "#############--- (set-signal! input-1 1) ---")
(set-signal! input-1 1)
(investigate-agenda)

(newline)
(display "#############--- (propagate) ---")
(propagate)
(investigate-agenda)

(newline)
(display "############# (set-signal! input-2 0) ---")
(set-signal! input-2 0)
(investigate-agenda)

(display "#############--- (propagate) ---")
(propagate)
(investigate-agenda)

;;; Answer

;;; Setting new value of the output is delayed (new output value has been generated in memory
;;;  by setting input signal)
;;;
;;; Initial wires' signals are (a b) = (0 1) and (add-gate ...) is called, the actions' queue and time is the
;;; following

;;; Q1. <makes output change when the wire 'a' is changed (for (a b) = (0 1))>:3
;;; Q2. <makes output change when the wire 'b' is changed (for (a b) = (0 1))>:3

;;; By calling set-signal! a from 0 to 1, queue is the following (one queue is added)
;;; Q1. <makes output change when the wire 'a' is changed (for (a b) = (0 1))>:3
;;; Q2. <makes output change when the wire 'b' is changed (for (a b) = (0 1))>:3
;;; Q3. <makes output change when the wire 'a' is changed (for (a b) = (1 1))>:3

;;; By calling set-signal! b from 1 to 0, queue is the following (one queue is added)
;;; Q1. <makes output change when the wire 'a' is changed (for (a b) = (0 1))>:3
;;; Q2. <makes output change when the wire 'b' is changed (for (a b) = (0 1))>:3
;;; Q3. <makes output change when the wire 'a' is changed (for (a b) = (1 1))>:3
;;; Q4. <makes output change when the wire 'b' is changed (for (a b) = (1 0))>:6

;;; For FIFO, the signals and times changes like the following by propagate,
;;;
;;; After Q1: output = 0:3
;;; After Q2: output = 0:3
;;; After Q3: output = 1:3 => result of [By calling set-signal! a from 0 to 1]
;;; After Q4: output = 0:6

;;; For FILO, the signals and times changes like the following by propagate,
;;;
;;; After Q3: output = 1:3
;;; After Q2: output = 0:3
;;; After Q1: output = 0:3 => result of [By calling set-signal! a from 0 to 1]
;;; After Q4: output = 0:6

;;; The intermediate result is not correct.

