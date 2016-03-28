;;;; Pattern matching

;; Pattern matcher: Takes as inputs a 'pattern', 'datum' and 'frame'
;; 'frame': Specifies bindings for various pattern variables

;;;; Streams of frames

;; Frames are given through stream.
;; For each frame, matching process to the database assertion entries generate the frames
;; whose symbols have been resolved by the assertions or failure as the resulting stream.

;;;; Compound queries

(and (can-do-job ?x (computer programmer trainee))
     (job ?person ?x))

;; The first predicate of 'and' generates the frames' stream which matchs all ?x candidates.
;; Then for each frame of the stream, generate and filter the frames where ?x and ?person are binded.

(or A B)
;; The input frame stream is filtered and extended by each of A and B, then the generated frames by each are merged
;; to generate the final output stream.
;; The matching pattern could increase exponentially, which leads to heavy processing.

(and (supervisor ?x ?y)
     (not (job? ?x (computer programmer))))

;; This generates the extension frames which have ?x ?y bindings.
;; Then filter by '(job? ?x (computer programmer))' and filter the exntension frames by the result of it.

;; For lisp-value, at first generating the frames which all variables are instantiated then filter
;; and apply them lisp-value predicate. All input frames are filtered out if the predicate fails.


;;;; Unification

;; to be continued
