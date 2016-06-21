(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")

;;;; Answer

;;;; Original query-driver-loop in ch4.4.4.1
;; (define (query-driver-loop)
;;   (prompt-for-input input-prompt)
;;   (let ((q (query-syntax-process (read)))) ;; transform syntactically for efficiency, change the representation of the pattern variables
;;     (cond ((assertion-to-be-added? q)
;;            (add-rule-or-assertion! (add-assertion-body q))
;;            (newline)
;;            (display "Assertion added to data base.")
;;            (query-driver-loop))
;;           (else
;;            (newline)
;;            (display output-prompt)
;;            (display-stream
;;             (stream-map
;;              (lambda (frame)
;;                (instantiate
;;                 q
;;                 frame
;;                 (lambda (v f)
;;                   (contract-question-mark v)))) ;; unbound variables are transformed back to the input representation, which is the 'unbound-var-handler' argument of 'instantiate'.
;;              (qeval q (singleton-stream '()))))
;;            (query-driver-loop)))))


(define (query-driver-loop)

  (define current-query 'failed)

  (define (instantiate-first-frame frames-stream)
    (if (stream-null? frames-stream)
        (begin
          (newline)
          (display output-prompt)
          (newline)
          (display ";;; There are no more frame.")
          (internal-loop the-empty-stream))
        (begin
          (newline)
          (display (instantiate
                    current-query
                    (stream-car frames-stream)
                    (lambda (v f)
                      (contract-question-mark v))))
          (internal-loop (stream-cdr frames-stream)))))

  (define (internal-loop frames-stream)
    (prompt-for-input input-prompt)
    (let ((q (query-syntax-process (read)))) ;; transform syntactically for efficiency, change the representation of the pattern variables
      (cond ((assertion-to-be-added? q)
             (add-rule-or-assertion! (add-assertion-body q))
             (newline)
             (display "Assertion added to data base.")
             (internal-loop frames-stream))
            ((try-again? q)
             (instantiate-first-frame frames-stream))
            (else
             (newline)
             (display output-prompt)
             (set! current-query q)
             (instantiate-first-frame
              (qeval q (singleton-stream '())))))))
  (internal-loop (singleton-stream '())))


(define (try-again? q)
  (eq? (type q) 'try-again))

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

")


;; ;;; test

;; ;;; Query input:
;; (and (salary ?x ?y) (lisp-value > ?y 40000))

;; ;;; Query result:
;; (and (salary (scrooge eben) 75000) (lisp-value > 75000 40000))

;; ;;; Query input:
;; (try-again)

;; (and (salary (warbucks oliver) 150000) (lisp-value > 150000 40000))

;; ;;; Query input:
;; (try-again)

;; (and (salary (bitdiddle ben) 60000) (lisp-value > 60000 40000))

;; ;;; Query input:
;; (try-again)

;; ;;; Query result:
;; ;;; There are no more frame.
