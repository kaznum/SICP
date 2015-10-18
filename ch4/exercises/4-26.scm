(define (analyze-unless exp)
  (analyze (unless->if exp)))

(define (unless? exp) (tagged-list? exp 'unless))

(define (unless-condition exp) (cadr exp))
(define (unless-usual exp) (caddr exp))
(define (unless-exceptional exp)
  (if (null? (cdddr exp))
      'false
      (cadddr exp)))

(define (unless->if exp)
  (make-if (unless-condition exp)
	   (unless-exceptional exp)
	   (unless-usual exp)))

;; from text and add 'unless' case
(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((let? exp) (analyze-let exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((begin? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((application? exp) (analyze-application exp))
	;; Added
	((unless? exp) (analyze-unless exp))
        (else (error "Unknown expression type: ANALYZE" exp))))


;; If unless is procedure, the following code will work well, but not for the special form
;; because in scheme, `procedure` is a first-class object and assignable/usable
;; as an argument, etc.
(define (either proc condition a b)
  (proc condition a b))

(either unless (= 2 1) true false)
;; => true
