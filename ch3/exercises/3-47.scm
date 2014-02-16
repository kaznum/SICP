;;
;; defined in the text
;;
(define (make-mutex)
  (let ((cell (list false)))
    (define (the-mutex m)
      (cond ((eq? m 'acquire)
	     (if (test-and-set! cell)
		 (the-mutex 'acquire)))
	    (eq? m 'release) (clear! cell))))
  the-mutex)

(define (clear! cell (set-car! cell false)))

(define (test-and-set! cell)
  (if (car cell) true (begin (set-car! cell true) false)))

;;
;; a.
;;
(define (make-semaphore n)
  (let ((count n)
	(count-mutex (make-mutex)))
    (define (the-semaphore s)
      (cond ((eq? s 'acquire)
	     (count-mutex 'acquire)
	     (if (zero? count)
		 (begin
		   (count-mutex 'release)
		   (the-semaphore 'acquire))
		 (begin
		   (set! count (- count 1))
		   (count-mutex 'release))))
	    ((eq? s 'release)
	     (count-mutex 'acquire)
	     (if (= n count)
		 (count-mutex 'release)
		 (begin
		   (set! count (+ count 1))
		   (count-mutex 'release))))))
    the-semaphore))

;;
;; b.
;;
(define (make-semaphore n)
  (let ((count n)
	(count-cell (list false)))
    (define (the-semaphore s)
      (cond ((eq? s 'acquire)
	     (if (test-and-set! count-cell)
		 (the-semaphore 'acquire)
		 (if (zero? count)
		     (clear! count-cell)
		     (begin
		       (set! count (- count 1))
		       (clear! count-cell)))))
	    ((eq? s 'release)
	     (if (test-and-set! count-cell)
		 (the-semaphore 'release)
		 (if (= n count)
		     (clear! count-cell)
		     (begin
		       (set! count (+ count 1))
		       (clear! count-cell)))))))
    the-semaphore))
