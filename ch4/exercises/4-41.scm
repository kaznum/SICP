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

  (define (remaining-dwelling results bs cs fs ms ss)
    (if (null? bs)
        results
        (let ((b (car bs)))
          (if (null? cs)
              (remaining-dwelling results (cdr bs) '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5))
              (let ((c (car cs)))
                (if (null? fs)
                    (remaining-dwelling results bs (cdr cs) '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5))
                    (let ((f (car fs)))
                      (if (null? ms)
                          (remaining-dwelling results bs cs (cdr fs) '(1 2 3 4 5) '(1 2 3 4 5))
                          (let ((m (car ms)))
                            (if (null? ss)
                                (remaining-dwelling results bs cs fs (cdr ms) '(1 2 3 4 5))
                                (let ((s (car ss)))
                                  (if (match? b c f m s)
                                      (remaining-dwelling (cons (list b c f m s) results)
                                                          bs cs fs ms (cdr ss))
                                      (remaining-dwelling results bs cs fs ms (cdr ss))))))))))))))


  (remaining-dwelling '() '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5) '(1 2 3 4 5)))


(multiple-dwelling)


;; 1 ]=>
;; ;Value 2: ((3 2 4 5 1))
