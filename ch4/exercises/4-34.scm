;;; Code From Text ch4.2.2
(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
	((variable? exp) (lookup-variable-value exp env))
	((quoted? exp) (text-of-quotation exp))
	((assignment? exp) (eval-assignment exp env))
	((definition? exp) (eval-definition exp env))
	((if? exp) (eval-if exp env))
	((lambda? exp) (make-procedure (lambda-parameters exp)
				       (lambda-body exp)
				       env))
        ;;
        ;; ex4.34: add pair-procedure definition
        ;;
	((pair-lambda? exp) (make-pair-procedure (pair-lambda-parameters exp)
                                                 (pair-lambda-body exp)
                                                 (pair-lambda-actuals exp)
                                                 env))
        ;; end of 'ex4.34: add pair-procedure definition'
	((begin? exp)
	 (eval-sequence (begin-actions exp) env))
	((cond? exp) (eval (cond->if exp) env))
	((let? exp)
	 (eval (let->combination exp) env))
        ;;
        ;; ex4.34: add definition of cons, car, cdr
        ;;
        ((cons? exp) (eval-cons exp env))
        ((car? exp) (eval-car exp env))
        ((cdr? exp) (eval-cdr exp env))
        ;; end of 'ex4.34: add definition of cons, car, cdr'

	((application? exp)
	 (apply (actual-value (operator exp) env)
		(operands exp)
		env))
	(else
	 (error "Unknown expression type: EVAL" exp))))

(define (actual-value exp env)
  (force-it (eval exp env)))

(define apply-in-underlying-scheme apply)
(define (apply procedure arguments env)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure
	  procedure
	  (list-of-arg-values arguments env)))
        ;; ex4-34: add condition for pair-procedure
        ((or (compound-procedure? procedure) (pair-procedure? procedure))
	 (eval-sequence
	  (procedure-body procedure)
	  (extend-environment
	   (procedure-parameters procedure)
	   (list-of-delayed-args arguments env)
	   (procedure-environment procedure))))
	(else
	 (error
	  "Unknown procedure type: APPLY" procedure))))

(define (list-of-arg-values exps env)
  (if (no-operands? exps)
      '()
      (cons (actual-value (first-operand exps)
			  env)
	    (list-of-arg-values (rest-operands exps)
				env))))

(define (list-of-delayed-args exps env)
  (if (no-operands? exps)
      '()
      (cons (delay-it (first-operand exps)
		      env)
	    (list-of-delayed-args (rest-operands exps) env))))

(define (eval-if exp env)
  (if (true? (actual-value (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

(define input-prompt ";;; L-Eval input:")
(define output-prompt ";;; L-Eval value:")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output
	   (actual-value
	    input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (eval-sequence exps env)
  (cond ((last-exp? exps)
	 (eval (first-exp exps) env))
	(else
	 (eval (first-exp exps) env)
	 (eval-sequence (rest-exps exps) env))))

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
		       (eval (assignment-value exp) env)
		       env)
  'ok)

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
    (eval (definition-value exp) env)
    env)
  'ok)


(define (self-evaluating? exp)
  (cond ((number? exp) true)
	((string? exp) true)
	(else false)))

(define (variable? exp) (symbol? exp))

(define (quoted? exp) (tagged-list? exp 'quote))

;;
;; ex4.34(modify ex4.33): add output expression of quoted list
;;
(define (text-of-quotation exp)
  (define (lazy-list texts)
    (if (null? texts)
        '()
        (make-pair-procedure '(m)
                             (list '(m car-value cdr-value))
                             texts
                             (extend-environment
                              (list 'car-value 'cdr-value)
                              (list (car texts) (lazy-list (cdr texts)))
                              the-empty-environment))))
  ;; "'(...)" equals to (quote (...))
  (let ((texts (cadr exp)))
    (if (or (null? texts) (pair? texts))
        (lazy-list texts)
        texts)))
;; end 'ex4.34(modify ex4.33): add output expression of quoted list'

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

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

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

;;
;; ex4-34: add accessor for pair-lambda params
;;
(define (pair-lambda? exp) (tagged-list? exp 'pair-lambda))
(define (pair-lambda-parameters exp) (cadr exp))
(define (pair-lambda-body exp) (caddr exp))
(define (pair-lambda-actuals exp) (caddr exp))
;; end of 'ex4-34: add accessor for pair-lambda params'

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

;;
;; ex4.34: add make-pair-lambda definition
;;
(define (make-pair-lambda parameters body actuals)
  (cons 'pair-lambda (list (cons parameters body) actuals)))
;; end of 'ex4.34: add make-pair-lambda definition'

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp) (cadr exp))
(define (if-consequent exp) (caddr exp))
(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

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

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))
(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

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

;;
;; ex4.34: add definition of cons, car, cdr
;;
(define (cons? x) (tagged-list? x 'cons))
(define (car? x) (tagged-list? x 'car))
(define (cdr? x) (tagged-list? x 'cdr))

(define (eval-cons exp env)
  ;; generate '(define (cons x y) (lambda (m) (m x y)))'
  (let ((m (generate-uninterned-symbol 'm))
        (x (cadr exp))
        (y (caddr exp)))
    (let ((actuals (cons (actual-value x env)
                       (if (cons? y)
                           '...
                           (actual-value y env)))))
      (eval (make-pair-lambda (list m) (list (list m x y)) actuals) env))))

(define (eval-car exp env)
  ;; generate (define (car z) (z (lambda (p q) p)))
  (let ((p (generate-uninterned-symbol 'p))
        (q (generate-uninterned-symbol 'q))
        (z (cadr exp)))
    (eval (list z (make-lambda (list p q) (list p))) env)))

(define (eval-cdr exp env)
  ;; generate (define (cdr z) (z (lambda (p q) q)))
  (let ((p (generate-uninterned-symbol 'p))
        (q (generate-uninterned-symbol 'q))
        (z (cadr exp)))
    (eval (list z (make-lambda (list p q) (list q))) env)))
;;
;; end of 'ex4.34: add definition of cons, car, cdr'
;;

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))

;;
;; ex4.34: add pair-procedure representation
;;
(define (make-pair-procedure parameters body actuals env)
  (list 'pair-procedure parameters body actuals env))
(define (pair-procedure? p)
  (tagged-list? p 'pair-procedure))
;; end of 'ex4.34: add pair-procedure representation'

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

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

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
	     (add-binding-to-frame! var val frame))
	    ((eq? var (car vars)) (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

(define (primitive-procedure-names)
  (map car primitive-procedures))
(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))
(define primitive-procedures
  (list
   ;; The primitive car, cdr and cons must not be used
   (list 'null? null?)
   (list '+ +)
   (list '* *)
   (list '= =)
   (list '- -)
   (list 'get-universal-time get-universal-time)
   (list 'display display)
   (list 'newline newline)
   ;; more
   ))


(define (setup-environment)
  (let ((initial-env
	 (extend-environment (primitive-procedure-names)
			     (primitive-procedure-objects)
			     the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))
(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))
(define (primitive-implementation proc) (cadr proc))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
(define (announce-output string)
  (newline) (display string) (newline))

(define (user-print object)
  (cond ((compound-procedure? object)
         (display (list 'compound-procedure
		     (procedure-parameters object)
		     (procedure-body object)
		     '<procedure-env>)))
        ;;
        ;; ex4.34: add printing for pair-procedure
        ;;
        ((pair-procedure? object)
         (user-print-for-pair object))
        ;; end of 'ex4.34: add printing for pair-procedure'
        (else (display object))))
;;
;; ex4.34 user-printer for pair
;;
(define (user-print-for-pair obj)
  (display (cadddr obj)))
;; end of 'ex4.34 printer for pair'

(define (let? exp) (tagged-list? exp 'let))
(define (let-clauses exp) (cadr exp))
(define (let-variables clauses) (map car clauses))
(define (let-operations clauses) (map cadr clauses))
(define (let-body exp) (cddr exp))
(define (let->combination exp)
  (cons (make-lambda (let-variables (let-clauses exp))
                     (let-body exp))
        (let-operations (let-clauses exp))))
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (if (eq? (car vals) '*unassigned*)
                 (error "value is *unassigned* : " var)
                 (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (delay-it exp env)
  (list 'thunk exp env))
(define (thunk? obj)
  (tagged-list? obj 'thunk))
(define (thunk-exp thunk) (cadr thunk))
(define (thunk-env thunk) (caddr thunk))

(define (evaluated-thunk? obj)
  (tagged-list? obj 'evaluated-thunk))
(define (thunk-value evaluated-thunk)
  (cadr evaluated-thunk))

(define (force-it obj)
  (cond ((thunk? obj)
	 (let ((result (actual-value (thunk-exp obj)
				     (thunk-env obj))))
	   (set-car! obj 'evaluated-thunk)
	   (set-car! (cdr obj)
		     result)
	   (set-cdr! (cdr obj)
		     '())
	   result))
	((evaluated-thunk? obj) (thunk-value obj))
	(else obj)))

(define the-global-environment (setup-environment))

;;; TEST

;; The following is run in scheme emulator

;; ;; (driver-loop)
;; ;;; L-Eval input:
;; (cons 1 2)

;; ;;; L-Eval value:
;; (1 . 2)

;; ;;; L-Eval input:
;; (cons 1 (cons 2 (cons 3 4)))

;; ;;; L-Eval value:
;; (1 . ...)

;; ;;; L-Eval input:
;; '(1 2 3)

;; ;;; L-Eval value:
;; (1 2 3)
