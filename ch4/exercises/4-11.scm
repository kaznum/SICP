;;; From text

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))
(define (compound-procedure? p)
  (tagged-list? p 'procedure))
(define (procedure-paramters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))

(define (enclosing-environment env) (cdr env))
(define (first-frame env) (car env))
(define the-empty-environment '())

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
	     (add-bind-to-frame! var val frame))
	    ((eq? var (car vars)) (set-car! vals val))
	    (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame) (frame-values frame))))

;;; Answer(The following procedures has been changed)
(define (make-frame variables values)
  (if (= (length variables) (length values))
      (if (null? variabless)
	  '()
	  (cons (cons (car variables) (var values))
		(make-frame (cdr variables (cdr values)))))
      (error "lengths of variables and values are different from each other")))

(define (frame-variables frame) (map car frame))
(define (frame-values frame) (map cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-cdr! frame frame)
  (set-car! frame (cons var val)))

