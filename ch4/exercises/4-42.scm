;; Betty: "Kitty was second in the examination. I was only third."
;; Ethel: "You’ll be glad to hear that I was on top. Joan was 2nd."
;; Joan: "I was third, and poor old Ethel was bottom."
;; Kitty: "I came out second. Mary was only fourth."
;; Mary: "I was fourth. Top place was taken by Betty."

;; The solution for ordinary scheme:
;;   The only `match` should be replaced

(define (dwelling)
  (define (distinct? items)
    (cond ((null? items) true)
          ((null? (cdr items)) true)
          ((member (car items) (cdr items)) false)
          (else (distinct? (cdr items)))))

  ;; the match condition is different from the ex4-41's one
  (define (match? b e j k m)
    (and (distinct? (list b e j k m))
         (or (and (= k 2) (not (= b 3)))
             (and (not (= k 2)) (= b 3)))
         (or (and (= e 1) (not (= j 2)))
             (and (not (= e 1)) (= j 2)))
         (or (and (= j 3) (not (= e 5)))
             (and (not (= j 3)) (= e 5)))
         (or (and (= k 2) (not (= m 4)))
             (and (not (= k 2)) (= m 4)))
         (or (and (= m 4) (not (= b 1)))
             (and (not (= m 4)) (= b 1)))))

  (define inits '(1 2 3 4 5))

  (define (recursive-dwelling results bs es js ks ms)
    (cond ((null? bs)
           results)
          ((null? es)
           (recursive-dwelling results (cdr bs) inits inits inits inits))
          ((null? js)
           (recursive-dwelling results bs (cdr es) inits inits inits))
          ((null? ks)
           (recursive-dwelling results bs es (cdr js) inits inits))
          ((null? ms)
           (recursive-dwelling results bs es js (cdr ks) inits))
          (else
           (let ((b (car bs))
                 (e (car es))
                 (j (car js))
                 (k (car ks))
                 (m (car ms)))
             (if (match? b e j k m)
                 (recursive-dwelling (cons (list b e j k m) results)
                                     bs es js ks (cdr ms))
                 (recursive-dwelling results bs es js ks (cdr ms)))))))

  (recursive-dwelling '() inits inits inits inits inits))

(dwelling)


;Value 3: ((3 5 2 1 4))
;; The answer is b = 3, e = 5 , j = 2, k = 1 , m = 4


;; the solution for Nondeterministic way
;; The changes are only for require statement

(define (multiple-dwelling)
  (define (distinct? items)
    (cond ((null? items) true)
          ((null? (cdr items)) true)
          ((member? (car items) (cdr items)) false)
          (else (distinct? (cdr items)))))

  (let ((betty (amd 1 2 3 4 5))
        (ethel (amd 1 2 3 4 5))
        (joan (amd 1 2 3 4 5))
        (kitty (amd 1 2 3 4 5))
        (mary (amd 1 2 3 4 5)))
    (require (distinct? (list betty ethel joan kitty mary)))
    (require (or (and (= kitty 2) (not (= betty 3)))
                 (and (not (= kitty 2)) (= betty 3))))
    (require (or (and (= ethel 1) (not (= joan 2)))
                 (and (not (= ethel 1)) (= joan 2))))
    (require (or (and (= joan 3) (not (= ethel 5)))
                 (and (not (= joan 3)) (= ethel 5))))
    (require (or (and (= kitty 2) (not (= mary 4)))
                 (and (not (= kitty 2)) (= mary 4))))
    (require (or (and (= mary 4) (not (= betty 1)))
                 (and (not (= mary 4)) (= betty 1))))
    (list ('betty betty)
          ('ethel ethel)
          ('joan joan)
          ('kitty kitty)
          ('mary mary))))




