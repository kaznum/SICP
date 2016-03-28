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

;; We need simultaneous equations

(?x ?x), ((a ?y c) (a b ?z)

?x = (a ?y c)
?x = (a b ?z)

(a ?y c) = (a b ?z)

?y = b
?z = c

?x = (a b c)

;; In general, a successful unification may not determin all of the variable value.

(?x a), ((b ?y) ?z)

?x = (b ?y)
?z = a
;; The unification above does not fail, ?x and ?y can be assigned.

;;;; Applying rules

(live-near ?x (Hacker Alyssa P))

;; First, try pattern matching to the original assertions in database,
;; but there is no match because there is no (live-near...) assertion in database.
;; Sedond, try to unify the conclusion of each rule.

;; 1. Unify the query with the conclusion of the rule to form an extension of the original frame
;; 2. Relative to the extended frame, evaluate the query formed by the body of the rule.

;;;; Simple queries


;; to be continued
