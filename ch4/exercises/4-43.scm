;; Mary Ann Moore’s father has a yacht and so has each of
;; his four friends: Colonel Downing, Mr. Hall, Sir Barnacle
;; Hood, and Dr. Parker. Each of the five also has one daughter
;; and each has named his yacht after a daughter of one of
;; the others. Sir Barnacle’s yacht is the Gabrielle, Mr. Moore
;; owns the Lorna; Mr. Hall the Rosalind. The Melissa, owned
;; by Colonel Downing, is named after Sir Barnacle’s daughter.
;; Gabrielle’s father owns the yacht that is named after
;; Dr. Parker’s daughter. Who is Lorna’s father?
;; Try to write the program so that it runs efficiently (see Exercise
;; 4.40). Also determine how many solutions there are
;; if we are not told that Mary Ann’s last name is Moore.

;; Solution A.
;; It is more efficient if making use of `let` to restrict the size of possible alternatives as possible

(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (define (daughter father)
    (car father))
  (define (yacht father)
    (cdr father))
  (define (filter lst p)
    (cond ((null? lst) (list))
          ((p (car lst)) (cons (car lst) (filter (cdr lst) p)))
          (else (filter (cdr lst) p))))
  (let ((moore (cons (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna) (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna))))
    (require (not (eq? (daughter moore) (yacht moore))))
    (require (eq? (daughter moore) 'mary))
    (require (eq? (yacht moore) 'lorna))
    (let ((downing (cons (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna) (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna))))
      (require (not (eq? (daughter downing) (yacht downing))))
      (require (eq? (yacht downing) 'melissa))
      (let ((hall (cons (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna) (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna))))
        (require (not (eq? (daughter hall) (yacht hall))))
        (require (eq? (yacht hall) 'rosalind))
        (let ((barnacle (cons (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna) (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna))))
          (require (eq? (yacht barnacle) 'gabrielle))
          (require (eq? (daughter barnacle) 'melissa))
          (require (not (eq? (daughter barnacle) (yacht barnacle))))
          (let ((parker (cons (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna) (amb 'mary 'melissa, 'rosalind, 'gabrielle 'lorna))))
            (require (not (eq? (daughter parker) (yacht parker))))
            (require (eq? (daughter parker) (yacht (filter (list moore downing hall barnacle parker) (lambda (x) (eq? (daughter x) 'gabrielle))))))
            (require (distinct? (list (daughter moore) (daughter downing) (daughter hall) (daughter barnacle) (daughter parker))))
            (require (distinct? (list (yacht moore) (yacht downing) (yacht hall) (yacht barnacle) (yacht parker))))
            (list (list 'moore-d (daughter moore))
                  (list 'downing-d (daughter downing))
                  (list 'hall-d (daughter hall))
                  (list 'barnacle-d (daughter barnacle))
                  (list 'parker-d (daughter parker)))))))))

;; Solution B.

;; WIP
