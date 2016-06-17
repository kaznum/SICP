(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")

;;;; Answer

;; For (and (job ?x (computer programmer)) (lisp-value > ?y 35000) (salary ?x ?y))

;; generates filter at first: (((? x) (AAA BBB)) (lazy lisp-value > ?y 35000))
;; and when filter is applied to it and find 'delay symbol, then
;; evaluate (salary ?x ?y) and (lisp-value ...).
;; When resolved changes the binding, or keeps it.

;;;; original lisp-value
;; (define (lisp-value call frame-stream)
;;   (stream-flatmap
;;    (lambda (frame)
;;      (if (execute
;;           (instantiate
;;            call
;;            frame
;;            (lambda (v f)
;;              (error "Unknown pat var: LISP-VALUE" v)))) ;; if there is unbound variable in 'call' with the frame, it makes an error occur.
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))
;; (put 'lisp-value 'qeval lisp-value)

;;;; original extend
;; (define (extend variable value frame)
;;   (cons (make-binding variable value) frame))

;;;; original execute
;; (define (execute exp)
;;   (apply (eval (predicate exp) user-initial-environment)
;;          (args exp)))

;;;; original negate(not)
;; (define (negate operands frame-stream)
;;   (stream-flatmap
;;    (lambda (frame)
;;      (if (stream-null? (qeval (negated-query operands) (singleton-stream frame)))
;;          (singleton-stream frame)
;;          the-empty-stream))
;;    frame-stream))
;; (put 'not 'qeval negate)


(define (execute exp)
  (if (has-unbound? exp)
      'unbound
      (apply (eval (predicate exp) user-initial-environment)
             (args exp))))

(define (lisp-value-lazy call frame-stream)
  (stream-flatmap
   (lambda (frame)
     (let ((result (execute (instantiate call
                                         frame
                                         (lambda (v f) 'unbound)))))
       (cond ((eq? result 'unbound)
              (singleton-stream (append-lazy-filter (cons 'lisp-value call) frame)))
             (result (singleton-stream frame))
             (else the-empty-stream))))
   frame-stream))

(put 'lisp-value 'qeval lisp-value-lazy)

;; replaced original
(define (extend variable value frame)
  (qeval-of-lazy (cons (make-binding variable value) frame)))

(define (qeval-of-lazy frame)
  (define lazies (filter lazy-filter? frame))
  (define assignments (filter (lambda (b) (not (lazy-filter? b))) frame))

  (if (null? lazies)
      assignments
      (let ((exp (cdr (car lazies))))
        (let ((results (qeval exp (singleton-stream assignments))))
          (if (stream-null? results)
              'failed
              (cons (car lazies) (qeval-of-lazy (append (cdr lazies) assignments))))))))

;; negate
(define (negate-lazy operands frame-stream)
  (stream-flatmap
   (lambda (frame)
     (let ((result (instantiate (negated-query operands)
                                frame
                                (lambda (v f) 'unbound))))
       (cond ((has-unbound? result)
              (singleton-stream (append-lazy-filter (cons 'not operands) frame)))
             ((stream-null? (qeval (negated-query operands) (singleton-stream frame)))
              (singleton-stream frame))
             (else the-empty-stream))))
   frame-stream))
(put 'not 'qeval negate-lazy)

(define (has-unbound? exp)
  (if (null? exp)
      #f
      (let ((first (car exp))
            (rest (cdr exp)))
        (cond ((pair? first)
               (or (has-unbound? first) (has-unbound? rest)))
              ((eq? 'unbound first) #t)
              (else (has-unbound? rest))))))

(define (append-lazy-filter exp frame)
  (cons (cons 'lazy-filter exp) frame))

(define (lazy-filter? binding) (eq? 'lazy-filter (car binding)))

(define sample "

(assert! (assert! (address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))))
(assert! (job (Bitdiddle Ben) (computer wizard)))
(assert! (salary (Bitdiddle Ben) 60000))
(assert! (address (Hacker Alyssa P) (Cambridge (Mass Ave) 78)))
(assert! (job (Hacker Alyssa P) (computer programmer)))
(assert! (salary (Hacker Alyssa P) 40000))
(assert! (supervisor (Hacker Alyssa P) (Bitdiddle Ben)))
(assert! (address (Fect Cy D) (Cambridge (Ames Street) 3)))
(assert! (job (Fect Cy D) (computer programmer)))
(assert! (salary (Fect Cy D) 35000))
(assert! (supervisor (Fect Cy D) (Bitdiddle Ben)))
(assert! (address (Tweakit Lem E) (Boston (Bay State Road) 22)))
(assert! (job (Tweakit Lem E) (computer technician)))
(assert! (salary (Tweakit Lem E) 25000))
(assert! (supervisor (Tweakit Lem E) (Bitdiddle Ben)))
(assert! (address (Reasoner Louis) (Slumerville (Pine Tree Road) 80)))
(assert! (job (Reasoner Louis) (computer programmer trainee)))
(assert! (salary (Reasoner Louis) 30000))
(assert! (supervisor (Reasoner Louis) (Hacker Alyssa P)))
(assert! (supervisor (Bitdiddle Ben) (Warbucks Oliver)))
(assert! (address (Warbucks Oliver) (Swellesley (Top Heap Road))))
(assert! (job (Warbucks Oliver) (administration big wheel)))
(assert! (salary (Warbucks Oliver) 150000))
(assert! (address (Scrooge Eben) (Weston (Shady Lane) 10)))
(assert! (job (Scrooge Eben) (accounting chief accountant)))
(assert! (salary (Scrooge Eben) 75000))
(assert! (supervisor (Scrooge Eben) (Warbucks Oliver)))
(assert! (address (Cratchet Robert) (Allston (N Harvard Street) 16)))
(assert! (job (Cratchet Robert) (accounting scrivener)))
(assert! (salary (Cratchet Robert) 18000))
(assert! (supervisor (Cratchet Robert) (Scrooge Eben)))
(assert! (address (Aull DeWitt) (Slumerville (Onion Square) 5)))
(assert! (job (Aull DeWitt) (administration secretary)))
(assert! (salary (Aull DeWitt) 25000))
(assert! (supervisor (Aull DeWitt) (Warbucks Oliver)))
(assert! (can-do-job (computer wizard) (computer programmer)))
(assert! (can-do-job (computer wizard) (computer technician)))
(assert! (can-do-job (computer programmer)
                     (computer programmer trainee)))
(assert! (can-do-job (administration secretary)
                     (administration big wheel)))

(and (job ?x (computer programmer)) (salary ?x ?y) (lisp-value > ?y 35000))
;; result:
;;  (and (job (hacker alyssa p) (computer programmer)) (salary (hacker alyssa p) 40000) (lisp-value > 40000 35000))

;; the following does not work in the original version
;; because ?y of '(lisp-value < ?y 35000)' is not defined
;; but it works in this version
(and (job ?x (computer programmer)) (lisp-value > ?y 35000) (salary ?x ?y))
;;; result:
;;   (and (job (hacker alyssa p) (computer programmer)) (lisp-value > 40000 35000) (salary (hacker alyssa p) 40000))
(and (job ?x (computer programmer)) (lisp-value < ?y 35000) (salary ?x ?y))
;; result:
;;  (none)

;; the following get one result
(and (job ?x (computer programmer)) (not (salary ?x 35000)))
;; result
;; (and (job (hacker alyssa p) (computer programmer)) (not (salary (hacker alyssa p) 35000)))

;; the following results in no frame in original version
;; because ?x is unbound
(and (not (salary ?x 35000)) (job ?x (computer programmer)))
;; result
;; (and (not (salary (hacker alyssa p) 35000)) (job (hacker alyssa p) (computer programmer)))
")
