(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query result:")

;; from ch4.1.4
(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))
;; end of 'from ch4.1.4'

;; from ch3.5..1
(define (display-stream s)
  (stream-for-each display-line s))
(define (display-line x) (newline) (display x))
;; end of 'from ch3.5.1'

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read)))) ;; transform syntactically for efficiency, change the representation of the pattern variables
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added to data base.")
           (query-driver-loop))
          (else
           (newline)
           (display output-prompt)
           (display-stream
            (stream-map
             (lambda (frame)
               (instantiate
                q
                frame
                (lambda (v f)
                  (contract-question-mark v)))) ;; unbound variables are transformed back to the input representation, which is the 'unbound-var-handler' argument of 'instantiate'.
             (qeval q (singleton-stream '()))))
           (query-driver-loop)))))

;; instantiate the expression by frame. Replacing variables with the values in frame.
;; At the same time, values themselves are instantiated.(for the case of ?x = ?y and ?y = 5)
(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
                 (copy (binding-value binding)) ;; for ?x which is bound to ?y
                 (unbound-var-handler exp frame))))
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp))) ;; this is for the real value which is not variable
  (copy exp))
