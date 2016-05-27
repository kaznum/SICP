(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")


;;;; Answer

(define (empty-frame? frame) (null? frame))
(define (first-binding frame) (car frame))
(define (rest-bindings frame) (cdr frame))
(define empty-frame '())

(define (unique-asserted operands frame-stream)
  (define (duplicated-binding? f1 f2)
    (if (empty-frame? f1)
        false
        (let ((binding (first-binding f1)))
          (let ((var (binding-variable binding))
                (val (binding-value binding)))
            (let ((binding-in-f2 (binding-in-frame var f2)))
              (cond ((not binding-in-f2)
                     (duplicated-binding? (rest-bindings f1) f2))
                    ((equal? val (binding-value binding-in-f2))
                     true)
                    (else
                     (duplicated-binding? (rest-bindings f1) f2))))))))

  (define (accumulate-unique-frames new-frame frames)
    (cond ((stream-null? frames)
           (cons-stream new-frame frames))
          ((duplicated-binding? (stream-car frames) new-frame)
           (accumulate-unique-frames new-frame (stream-cdr frames)))
          (else
           (cons-stream (stream-car frames)
                        (accumulate-unique-frames new-frame (stream-cdr frames))))))

  (define unique-frames the-empty-stream)

  (stream-flatmap
   (lambda (frame)
     (let ((tmp-frames unique-frames))
       (set! unique-frames (accumulate-unique-frames frame tmp-frames))))
   (qeval (car operands) frame-stream))
  unique-frames)

(put 'unique 'qeval unique-asserted)

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

(unique (job ?x (computer wizard)))
(unique (job ?x (computer programmer)))
(and (job ?x ?j) (unique (job ?anyone ?j)))

")

;; to be continued
;; It is not enough to comparing frames because (computer programmer) in (unique (job ?x (computer programmer))) is not variable.

