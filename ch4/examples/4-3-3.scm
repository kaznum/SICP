;; From the text ch4.1.7
(define (eval exp env) ((analyze exp) env))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())
(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

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

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))
(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

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
             (add-bind-to-frame! var val frame))
            ((eq? var (car vars)) (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame)))

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

;;; The followings will be redefined in this chapter.

;; (define (analyze-self-evaluating exp)
;;   (lambda (env) exp))

;; (define (analyze-quoted exp)
;;   (let ((qval (text-of-quotation exp)))
;;     (lambda (env) qval)))

;; (define (analyze-variable exp)
;;   (lambda (env) (lookup-variable-value exp env)))

;; (define (analyze-assignment exp)
;;   (let ((var (assignment-variable exp))
;; 	(vproc (analyze (assignment-value exp))))
;;     (lambda (env)
;;       (set-variable-value! var (vproc env) env)
;;       'ok)))

;; (define (analyze-definition exp)
;;   (let ((var (definition-variable exp))
;; 	(vproc (analyze (definition-value exp))))
;;     (lambda (env)
;;       (define-variable! var (vproc env) env)
;;       'ok)))

;; (define (analyze-if exp)
;;   (let ((pproc (analyze (if-predicate exp)))
;; 	(cproc (analyze (if-consequent exp)))
;; 	(aproc (analyze (if-alternative exp))))
;;     (lambda (env) (if (true? (pproc env))
;; 		      (cproc env)
;; 		      (aproc env)))))

;; (define (analyze-lambda exp)
;;   (let ((vars (lambda-parameters exp))
;; 	(bproc (analyze-sequence (lambda-body exp))))
;;     (lambda (env) (make-procedure vars bproc env))))

;; (define (analyze-sequence exps)
;;   (define (sequentially proc1 proc2)
;;     (lambda (env) (proc1 env) (proc2 env)))
;;   (define (loop first-proc rest-procs)
;;     (if (null? rest-procs)
;; 	first-proc
;; 	(loop (sequentially first-proc (car rest-procs))
;; 	      (cdr rest-procs))))
;;   (let ((procs (map analyze exps)))
;;     (if (null? procs) (error "Empty sequence: ANALYZE"))
;;     (loop (car procs) (cdr procs))))

;; (define (analyze-application exp)
;;   (let ((fproc (analyze (operator exp)))
;; 	(aprocs (map analyze (operands exp))))
;;     (lambda (env)
;;       (execute-application
;;        (fproc env)
;;        (map (lambda (aproc) (aproc env))
;; 	    aprocs)))))
;; (define (execute-application proc args)
;;   (cond ((primitive-procedure? proc)
;; 	 (apply-primitive-procedure proc args))
;; 	((compound-procedure? proc)
;; 	 ((procedure-body proc)
;; 	  (extend-environment (procedure-parameters proc)
;; 			      args
;; 			      (procedure-environment proc))))
;; 	(else
;; 	 (error "Unknown procedure type: EXECUTE-APPLICATION"
;; 		proc))))


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

(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
	((quoted? exp) (analyze-quoted exp))
	((variable? exp) (analyze-variable exp))
	((let? exp) (analyze-let exp))
        ;; added for amb evaluator
        ((amb? exp) (analyze-amb exp))
	((assignment? exp) (analyze-assignment exp))
	((definition? exp) (analyze-definition exp))
	((if? exp) (analyze-if exp))
	((lambda? exp) (analyze-lambda exp))
	((begin? exp) (analyze-sequence (begin-actions exp)))
	((cond? exp) (analyze (cond->if exp)))
	((application? exp) (analyze-application exp))
	(else (error "Unknown expression type: ANALYZE" exp))))

(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))

;; the general form of execution procedure is
;;
;; (lambda (env succeed fail)
;;   ;; succeed is (lambda (value fail) : : :)
;;   ;; fail is (lambda () : : :)
;;   ...)

;; example
;; (ambeval <exp>
;;          the-global-environment
;;          (lambda (value fail) value)
;;          (lambda () 'failed))
;; returns the expression's value or the symbol 'failed

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
   (define (sequentially proc1 prob2)
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
    (lambda (evn succeed fail)
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

;; to be continued
