;;;; Deductive Information Retrieval

;;;; A sample data base
(address (Bitdiddle Ben) (Slumerville (Ridge Road) 10))
(job (Bitdiddle Ben) (computer wizard))
(salary (Bitdiddle Ben) 60000)

(address (Hacker Alyssa P) (Cambridge (Mass Ave) 78))
(job (Hacker Alyssa P) (computer programmer))
(salary (Hacker Alyssa P) 40000)
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))
(address (Fect Cy D) (Cambridge (Ames Street) 3))
(job (Fect Cy D) (computer programmer))
(salary (Fect Cy D) 35000)
(supervisor (Fect Cy D) (Bitdiddle Ben))
(address (Tweakit Lem E) (Boston (Bay State Road) 22))
(job (Tweakit Lem E) (computer technician))
(salary (Tweakit Lem E) 25000)
(supervisor (Tweakit Lem E) (Bitdiddle Ben))

(address (Reasoner Louis) (Slumerville (Pine Tree Road) 80))
(job (Reasoner Louis) (computer programmer trainee))
(salary (Reasoner Louis) 30000)
(supervisor (Reasoner Louis) (Hacker Alyssa P))

(supervisor (Bitdiddle Ben) (Warbucks Oliver))
(address (Warbucks Oliver) (Swellesley (Top Heap Road)))
(job (Warbucks Oliver) (administration big wheel))
(salary (Warbucks Oliver) 150000)

(address (Scrooge Eben) (Weston (Shady Lane) 10))
(job (Scrooge Eben) (accounting chief accountant))
(salary (Scrooge Eben) 75000)
(supervisor (Scrooge Eben) (Warbucks Oliver))
(address (Cratchet Robert) (Allston (N Harvard Street) 16))
(job (Cratchet Robert) (accounting scrivener))
(salary (Cratchet Robert) 18000)
(supervisor (Cratchet Robert) (Scrooge Eben))

(address (Aull DeWitt) (Slumerville (Onion Square) 5))
(job (Aull DeWitt) (administration secretary))
(salary (Aull DeWitt) 25000)
(supervisor (Aull DeWitt) (Warbucks Oliver))

(can-do-job (computer wizard) (computer programmer))
(can-do-job (computer wizard) (computer technician))

(can-do-job (computer programmer)
            (computer programmer trainee))
(can-do-job (administration secretary)
            (administration big wheel))

;;;; Simple queries

(job ?x (computer programmer)
(address ?x ?y)
(supervisor ?x ?x)
(job ?x (computer ?type))
(job ?x (computer . ?type))

;;;; Compound queries
(and (job ?person (computer programmer))
     (address ?person ?where))

(or (supervisor ?x (Bitdiddle Ben))
    (supervisor ?x (Hacker Alyssa P)))

(and (supervisor ?x (Bitdiddle Ben))
     (not (job ?x (computer programmer))))

(and (salary ?person ?amount) (lisp-value > ?amount 30000))

;;;; Rules

(rule (live-near ?person-1 ?person-2)
      (address ?person-1 (?town . ?rest-1))
      (address ?person-2 (?town . ?rest-2))
      (not (same ?person-1 ?person-2)))

(rule (same ?x ?x))

(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))

(live-near ?x (Bitdiddle Ben))

(and (job ?x (computer programmer))
     (live-near ?x (Bitdiddle Ben)))

(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))


;;;; Logic as programs
(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))


;; query
(append-to-form (a b) (c d) ?z)
;; result
(append-to-form (b) (c d) j)  ;; where (a . j) = ?z
(append-to-form () (c d)  k) ;; where (b . k) = j
;; => k = (c d)
;; => j = (b c d)
;; => ?z = (a b c d)

(append-to-form (a b) (c d) (a b c d))

;; to be continued
