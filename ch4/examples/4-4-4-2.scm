;; returns the stream of extended frames
(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
        (qproc (contents query) frame-stream)
        (simple-query query frame-stream))))

;;;; Simple queries

;; takes the arguments a simple query and the stream of frames.
;; and returns the streams of extended frames by all database matches.

(define (simple-query query-pattern frame-stream)
  (stream-flatmap  ;; form the large stream of all the frames extended from each of the input frames.
   (lambda (frame)
     (stream-append-delayed  ;;  combines the two streams of frames
      (find-assertions query-pattern frame) ;; find the matching pattern from database and return extended frames for each frame.
      (delay (apply-rules query-pattern frame)))) ;; apply all the rules to the frame and generates the extended frames
   frame-stream))

;;;; Compound queries

(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
      frame-stream
      (conjoin (rest-conjunctions conjuncts)
               (qeval (first-conjunction conjuncts) frame-stream))))

;; put is not defined so far in the book
;; see http://stackoverflow.com/questions/5499005/how-do-i-get-the-functions-put-and-get-in-sicp-scheme-exercise-2-78-and-on

(put 'and 'qeval conjoin)

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave-delayed
       (qeval (first-disjunction disjuncts) frame-stream)
       (delay disjoin (rest-disjuncts) frame-stream))))

(put 'or 'qeval disjoin)


;;;; Filters
(define (negate operands frame-stream)
  (stream-flatmap
   (lambda (frame)
     (if (stream-null? (qeval (negated-query operands) (singleton-stream frame)))
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

(put 'not 'qeval negate)

(define (lisp-value call frame-stream)
  (stream-flatmap
   (lambda (frame)
     (if (execute
          (instantiate
           call
           frame
           (lambda (v f)
             (error "Unknown pat var: LISP-VALUE" v)))) ;; if there is unbound variable in 'call' with the frame, an error occurs
         (singleton-stream frame)
         the-empty-stream))
   frame-stream))

(put 'lisp-value 'qeval lisp-value)


;; 'execute' uses underlying Lisp system.
;; It must evaluate the predicate, but must not evaluate the arguments because they are already actual values
(define (execute exp)
  (apply (eval (predicate exp) user-initial-environment)
         (args exp)))

(define (always-true ignore frame-stream) frame-stream)
(put 'always-true 'qeval always-true)
