(define (multiple-dwelling)
  (define (distinct? items)
    (cond ((null? items) true)
          ((null? (cdr items)) true)
          ((member (car items) (cdr items)) false)
          (else (distinct? (cdr items)))))

  (define (match? b c f m s)
    (and (distinct? (list b c f m s))
         (not (= f 5))
         (not (= f 1))
         (not (= c 1))
         (not (= (abs (- f c)) 1))
         (> m c)
         (not (= b 5))
         (not (= (abs (- s f)) 1))))

  (define inits '(1 2 3 4 5))

  (define (recursive-dwelling results bs cs fs ms ss)
    (cond ((null? bs)
           results)
          ((null? cs)
           (recursive-dwelling results (cdr bs) inits inits inits inits))
           ((null? fs)
            (recursive-dwelling results bs (cdr cs) inits inits inits))
           ((null? ms)
            (recursive-dwelling results bs cs (cdr fs) inits inits))
           ((null? ss)
            (recursive-dwelling results bs cs fs (cdr ms) inits))
           (else
            (let ((b (car bs))
                  (c (car cs))
                  (f (car fs))
                  (m (car ms))
                  (s (car ss)))
              (if (match? b c f m s)
                  (recursive-dwelling (cons (list b c f m s) results)
                                      bs cs fs ms (cdr ss))
                  (recursive-dwelling results bs cs fs ms (cdr ss)))))))

  (recursive-dwelling '() inits inits inits inits inits))


(multiple-dwelling)


;; 1 ]=>
;; ;Value 2: ((3 2 4 5 1))
