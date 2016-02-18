;; From the text ch4.1.7
(define (eval exp env) ((analyze exp) env))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))
(define (text-of-quotation exp) (cadr exp))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))
(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments applied" vars vals)
          (error "Too few arguments applied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (definition? exp) (tagged-list? exp 'define))
(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)   ;; formal parameters
                   (cddr exp)))) ;; body

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))
(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))
(define (cond->if exp) (expand-clauses (cond-clauses exp)))
(define (expand-clauses clauses)
  (if (null? clauses)
      'false
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last: COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define (primitive-procedure-names)
  (map car primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define apply-in-underlying-scheme apply)
(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure
          procedure
          (list-of-arg-values arguments env)))
        ((compound-procedure? procedure)
         (eval-sequence
          (procedure-body procedure)
          (extend-environment
           (procedure-parameters procedure)
           (list-of-delayed-args arguments env)
           (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type: APPLY" procedure))))


(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '* *)
        (list '= =)
        (list '- -)
        (list 'eq? eq?)
        (list 'get-universal-time get-universal-time)
        (list 'display display)
        (list 'newline newline)
        (list 'list list)
        (list 'append append)
        ;; more
        ))
(define the-global-environment (setup-environment))


;; code from ex4.22 (analysis of 'let')
(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cadr exp))
(define (let-variables clauses) (map car clauses))
(define (let-operations clauses) (map cadr clauses))
(define (let-body exp) (cddr exp))
(define (let->combination exp)
  (cons (make-lambda (let-variables (let-clauses exp))
		     (let-body exp))
	(let-operations (let-clauses exp))))
(define (analyze-let exp)
  (analyze (let->combination exp)))

;;;; TEXT of ch4.3.3
;;;; Structure of the evaluator
(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))

;;;;
;;;; redefined in ex4.50
;;;;
;; (define (analyze exp)
;;   (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
;; 	((quoted? exp) (analyze-quoted exp))
;; 	((variable? exp) (analyze-variable exp))
;; 	((let? exp) (analyze-let exp))
;;         ;; added for amb evaluator
;;         ((amb? exp) (analyze-amb exp))
;; 	((assignment? exp) (analyze-assignment exp))
;; 	((definition? exp) (analyze-definition exp))
;; 	((if? exp) (analyze-if exp))
;; 	((lambda? exp) (analyze-lambda exp))
;; 	((begin? exp) (analyze-sequence (begin-actions exp)))
;; 	((cond? exp) (analyze (cond->if exp)))
;; 	((application? exp) (analyze-application exp))
;; 	(else (error "Unknown expression type: ANALYZE" exp))))

(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))

;;;; Simple expressions

(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
    (succeed exp fail)))

(define (analyze-quoted exp)
  (let ((qval (text-of-quotation exp)))
    (lambda (env succeed fail)
      (succeed qval fail))))

(define (analyze-variable exp)
  (lambda (env succeed fail)
    (succeed (lookup-variable-value exp env) fail)))

(define (analyze-lambda exp)
  (let ((vars (lambda-parameters exp))
        (bproc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail) (succeed (make-procedure vars bproc env) fail))))

;;;; Conditionals and sequences

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
        (cproc (analyze (if-consequent exp)))
        (aproc (analyze (if-alternative exp))))
    (lambda (env succeed fail)
      (pproc env
             ;; The success continuation whose predicate is true/false or fail
             (lambda (pred-value fail2)
               (if (true? pred-value)
                   (cproc env succeed fail2)
                   (aproc env succeed fail2)))
             ;; The failure continuation of evaluating the if's predicate
             fail))))

(define (analyze-sequence exps)
  (define (sequentially proc1 proc2)
    (lambda (env succeed fail)
      (proc1 env
             (lambda (proc1-value fail2)
               (proc2 env succeed fail2))
             fail)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
        first-proc
        (loop (sequentially first-proc (car rest-procs))
              (cdr rest-procs))))
  (let ((procs (map analyze exps)))
    (if (null? procs) (error "Empty sequence: ANALYZE"))
    (loop (car procs) (cdr procs))))


;;;; Definitions and assignments

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
        (vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)
               (define-variable! var val env)
               (succeed 'ok fail2))
             fail))))

(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
        (vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
             (lambda (val fail2)
               (let ((old-val
                      (lookup-variable-value var env)))
                 (set-variable-value! var val env)
                 (succeed 'ok
                          (lambda ()
                            (set-variable-value! var old-val env)
                            (fail2)))))
             fail))))

;;;; Procedure applications

(define (analyze-application exp)
  (let ((fproc (analyze (operator exp)))
 	(aprocs (map analyze (operands exp))))
    (lambda (env succeed fail)
      (fproc env
             (lambda (proc fail2)
               (get-args aprocs
                         env
                         (lambda (args fail3)
                           (execute-application
                            proc args succeed fail3))
                         fail2))
             fail))))

(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs)
       env
       (lambda (arg fail2)
         (get-args (cdr aprocs) env
                   (lambda (args fail3)
                     (succeed (cons arg args) fail3))
                   fail2))
       fail)))

(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
         (succeed (apply-primitive-procedure proc args)
                  fail))
        ((compound-procedure? proc)
         ((procedure-body proc)
          (extend-environment
           (procedure-parameters proc)
           args
           (procedure-environment proc))
          succeed fail))
        (else
         (error "Unknown procedure type: EXECUTE-APPLICATION"
                proc))))

;;;; Evaluating amb expressions

(define (analyze-amb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
            (fail)
            ((car choices) env succeed (lambda () (try-next (cdr choices))))))
      (try-next cprocs))))

;;;; Driver loop

(define input-prompt ";;; Amb-eval input:")
(define output-prompt ";;; Amb-eval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
          (try-again)
          (begin
            (newline) (display ";;; Starting a new problem ")
            (ambeval
             input
             the-global-environment
             ;; ambeval success
             (lambda (val next-alternative)
               (announce-output output-prompt)
               (user-print val)
               (internal-loop next-alternative))
             ;; ambeval failure
             (lambda ()
               (announce-output ";;; There are no more value of")
               (user-print input)
               (driver-loop)))))))
  (internal-loop
   (lambda ()
     (newline) (display ";;; There is no current problem")
     (driver-loop))))

;;;; Answer ex4.50

(define (ramb? exp) (tagged-list? exp 'ramb))

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
	((quoted? exp) (analyze-quoted exp))
	((variable? exp) (analyze-variable exp))
	((let? exp) (analyze-let exp))
        ((amb? exp) (analyze-amb exp))
        ;; added for ex4.50
        ((ramb? exp) (analyze-ramb exp))
	((assignment? exp) (analyze-assignment exp))
	((definition? exp) (analyze-definition exp))
	((if? exp) (analyze-if exp))
	((lambda? exp) (analyze-lambda exp))
	((begin? exp) (analyze-sequence (begin-actions exp)))
	((cond? exp) (analyze (cond->if exp)))
	((application? exp) (analyze-application exp))
	(else (error "Unknown expression type: ANALYZE" exp))))

(define (analyze-ramb exp)
  (let ((cprocs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
        (if (null? choices)
            (fail)
            ;;;; change from analyze-amb
            ;; ((car choices) env succeed (lambda () (try-next (cdr choices))))))
            (let ((index (random (length choices))))
              ((list-ref choices index)
               env
               succeed
               (lambda () (try-next (append (list-head choices index) (cdr (list-tail choices index)))))))))
      (try-next cprocs))))

;; ;;;; test
;; ;;; Amb-eval input:
;;  (ramb 1 2 3 4 5)
;; ;;; Starting a new problem 
;; ;;; Amb-eval value:
;; 1
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; 4
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; 3
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; 5
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; 2
;; ;;; Amb-eval input:
;; try-again
;; ;;; There are no more value of
;; (ramb 1 2 3 4 5)


;; consideration about ex4.49

;; when 'amb' is used, the (prep-phrase) are appended to  verb-phrase and not to noun-phrase.
;; on the other hand, 'ramb' generate randomly the sentences which have prep-phrases both on noun-phrase and verb-phrase.

;;;;
;;;; 'amb' used.....
;;;;

;; ;;; Amb-eval input:
;; (parse-sentence)
;; ;;; Starting a new problem 
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb studies))
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))))
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))))
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))))
;; ;;; Amb-eval input:
;; try-again
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))

;;;;
;;;; ramb is used...
;;;;

;; ;;; Amb-eval input:
;; (parse-sentence)

;; ;;; Starting a new problem 
;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb studies))

;; ;;; Amb-eval input:
;; try-again

;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb studies) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun professor)) (prep-phrase (prep for) (noun-phrase (noun-phrase (noun-phrase (simple-noun-phrase (article the) (noun cat)) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))))))))

;; ;;; Amb-eval input:
;; try-again

;; ;;; Amb-eval value:
;; (sentence (simple-noun-phrase (article the) (noun student)) (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb-phrase (verb studies) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun professor)) (prep-phrase (prep for) (noun-phrase (noun-phrase (noun-phrase (simple-noun-phrase (article the) (noun cat)) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))))))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))) (prep-phrase (prep for) (noun-phrase (noun-phrase (noun-phrase (simple-noun-phrase (article a) (noun class)) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))))) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun class)) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun professor)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))) (prep-phrase (prep for) (noun-phrase (noun-phrase (simple-noun-phrase (article a) (noun class)) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun professor)) (prep-phrase (prep for) (noun-phrase (noun-phrase (simple-noun-phrase (article the) (noun cat)) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))))))))) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun professor)) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article the) (noun cat)) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))))))) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun student)))) (prep-phrase (prep for) (noun-phrase (simple-noun-phrase (article a) (noun professor)) (prep-phrase (prep for) (simple-noun-phrase (article the) (noun cat)))))) (prep-phrase (prep for) (simple-noun-phrase (article a) (noun class)))))
