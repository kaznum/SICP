;; analyze-sequence
;; Single expression
(begin
  (proc1))

;; When analyze-sequence is called in Text version,
;; the result is
<result of (analyze-application proc1)>

;; in Alyssa's version
(lambda (env) (execute-sequence (list <result of (analyze-application proc1)>) env))


;; Multiple expression
(begin
  (proc1)
  (proc2))

;; in Text version,
(loop (sequentially <result of (analyze-application proc1)>
		    <result of (analyze-application proc2)>) '())
;; ->
(sequentially <result of (analyze-application proc1)>
	      <result of (analyze-application proc2)>)
;; ->
(lambda (env)
  (<result of (analyze-application proc1)> env)
  (<result of (analyze-application proc2)> env))


;; in Alyssa's version,
(lambda (env)
  (execute-sequence (list <result of analyze-application proc1>
			  <result of analyze-application proc2>)
		    env))

;; The Text version analyzes the sequences in 'analyze',
;; but Alyssa's version does not analyze the sequence in 'analyze',
;; This means Alyssa's version still has the staffs to be analyzed and
;; is less efficient at runtime.
