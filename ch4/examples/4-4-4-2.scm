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

(put 'and 'qeval conjoin)

(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
      the-empty-stream
      (interleave-delayed
       (qeval (first-disjunction disjuncts) frame-stream)
       (delay disjoin (rest-disjuncts) frame-stream))))

(put 'or 'qeval disjoin)

;;;; Filters


;; to be continued
