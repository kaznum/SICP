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
  (define (first lst p)
    (cond ((null? lst) false)
          ((p (car lst)) (car lst))
          (else (first (cdr lst) p))))
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
            (require (eq? (daughter parker) (yacht
                                             (let ((fst (first (list moore downing hall barnacle parker) (lambda (x) (eq? (daughter x) 'gabrielle)))))
                                               (if fst fst (cons 'none 'none))))))
            (require (distinct? (list (daughter moore) (daughter downing) (daughter hall) (daughter barnacle) (daughter parker))))
            (require (distinct? (list (yacht moore) (yacht downing) (yacht hall) (yacht barnacle) (yacht parker))))
            (list (list 'moore-d (daughter moore))
                  (list 'downing-d (daughter downing))
                  (list 'hall-d (daughter hall))
                  (list 'barnacle-d (daughter barnacle))
                  (list 'parker-d (daughter parker)))))))))


;;
;; Solution B.
;;
;; Now (amd) and (require) have not been defined yet, then use the ordinal scheme

(define (ordinal-multiple-dwelling)
  (define (distinct? items)
    (cond ((null? items) true)
          ((null? (cdr items)) true)
          ((member (car items) (cdr items)) false)
          (else (distinct? (cdr items)))))

  (define (daughter father)
    (car father))

  (define (yacht father)
    (cdr father))

  (define (make-father d y)
    (cons d y))

  (define (first lst p)
    (cond ((null? lst) false)
          ((p (car lst)) (car lst))
          (else (first (cdr lst) p))))

  (define (match? moore downing hall barnacle parker)
    (and (not (eq? (daughter moore) (yacht moore)))
         (eq? (daughter moore) 'mary)  ;; Commentout for Solution of C
         (eq? (yacht moore) 'lorna)
         (not (eq? (daughter downing) (yacht downing)))
         (eq? (yacht downing) 'melissa)
         (not (eq? (daughter hall) (yacht hall)))
         (eq? (yacht hall) 'rosalind)
         (eq? (yacht barnacle) 'gabrielle)
         (eq? (daughter barnacle) 'melissa)
         (not (eq? (daughter barnacle) (yacht barnacle)))
         (not (eq? (daughter parker) (yacht parker)))
         (eq? (daughter parker) (yacht
                                 (let ((fst (first (list moore downing hall barnacle parker) (lambda (x) (eq? (daughter x) 'gabrielle)))))
                                   (if fst fst (cons 'none 'none)))))
         (distinct? (list (daughter moore) (daughter downing) (daughter hall) (daughter barnacle) (daughter parker)))
         (distinct? (list (yacht moore) (yacht downing) (yacht hall) (yacht barnacle) (yacht parker)))))

  (define inits (list 'mary 'melissa 'rosalind 'gabrielle 'lorna))

  (define (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds h-ys b-ds b-ys p-ds p-ys)
    (cond ((null? m-ds)
           results)
          ((null? m-ys)
           (recursive-dwelling results (cdr m-ds) inits inits inits inits inits inits inits inits inits))
          ((null? d-ds)
           (recursive-dwelling results m-ds (cdr m-ys) inits inits inits inits inits inits inits inits))
          ((null? d-ys)
           (recursive-dwelling results m-ds m-ys (cdr d-ds) inits inits inits inits inits inits inits))
          ((null? h-ds)
           (recursive-dwelling results m-ds m-ys d-ds (cdr d-ys) inits inits inits inits inits inits))
          ((null? h-ys)
           (recursive-dwelling results m-ds m-ys d-ds d-ys (cdr h-ds) inits inits inits inits inits))
          ((null? b-ds)
           (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds (cdr h-ys) inits inits inits inits))
          ((null? b-ys)
           (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds h-ys (cdr b-ds) inits inits inits))
          ((null? p-ds)
           (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds h-ys b-ds (cdr b-ys) inits inits))
          ((null? p-ys)
           (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds h-ys b-ds b-ys (cdr p-ds) inits))
          (else
           (let ((m (make-father (car m-ds) (car m-ys)))
                 (d (make-father (car d-ds) (car d-ys)))
                 (h (make-father (car h-ds) (car h-ys)))
                 (b (make-father (car b-ds) (car b-ys)))
                 (p (make-father (car p-ds) (car p-ys))))
             (if (match? m d h b p)
                 (recursive-dwelling (cons (list (list 'moore (daughter m) (yacht m))
                                                 (list 'downing (daughter d) (yacht d))
                                                 (list 'hall (daughter h) (yacht h))
                                                 (list 'barnacle (daughter b) (yacht b))
                                                 (list 'parker (daughter p) (yacht p)))
                                           results)
                                     m-ds m-ys d-ds d-ys h-ds h-ys b-ds b-ys p-ds (cdr p-ys))
                 (recursive-dwelling results m-ds m-ys d-ds d-ys h-ds h-ys b-ds b-ys p-ds (cdr p-ys)))))))
  (recursive-dwelling '() inits inits inits inits inits inits inits inits inits inits))

(ordinal-multiple-dwelling)

;Value 2: (((moore mary lorna) (downing lorna melissa) (hall gabrielle rosalind) (barnacle melissa gabrielle) (parker rosalind mary)))
;; Lorna's father is Downing

;;
;; Solution C.
;;
;; If elimitating the condition `(eq? (daughter moore) 'mary)`, the possible answers are...

;Value 5:
;;(((moore gabrielle lorna) (downing rosalind melissa) (hall mary rosalind) (barnacle melissa gabrielle) (parker lorna mary))
;;((moore mary lorna) (downing lorna melissa) (hall gabrielle rosalind) (barnacle melissa gabrielle) (parker rosalind mary)))
