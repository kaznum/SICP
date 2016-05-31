(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")

;;;; original implementation of and
;; (define (conjoin conjuncts frame-stream)
;;   (if (empty-conjunction? conjuncts)
;;       frame-stream
;;       (conjoin (rest-conjuncts conjuncts)
;;                (qeval (first-conjunct conjuncts) frame-stream))))
;; (put 'and 'qeval conjoin)

(define (efficient-conjoin conjuncts frame-stream)
  (define (except var f)
    (if (binding-in-frame var f)
        (if (equal? var (binding-variable (car f)))
            (cdr f)
            (cons (car f) (except var (cdr f))))
        f))

  (define (merge-stream-frames f1 f2)
    (if (null? f1)
        f2
        (let ((first-binding (car f1)))
          (let ((var (binding-variable first-binding))
                (val (binding-value first-binding)))
            (let ((f2-binding (binding-in-frame var f2)))
              (if f2-binding
                  (if (equal? val (binding-value f2-binding))
                      (cons first-binding (merge-stream-frames (cdr f1) (except var f2)))
                      'fail)
                  (cons first-binding (merge-stream-frames (cdr f1) f2))))))))

;;; to be continued
  (if (empty-conjunction? conjuncts)
      frame-stream
      (stream-map
       (lambda (frame)
         (merge-frames 
                       (qeval (first-conjunct conjuncts)  (singleton-stream frame))
                       
                       
          (map
           (lambda (conjunct)
             (qeval conjunct (singleton-stream frame)))
           conjuncts)))
        frame-stream)))

(put 'and 'qeval efficient-conjoin)


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

