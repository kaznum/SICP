(define (distinct? items)
  (cond ((null? items) true)
        ((null? (cdr items)) true)
        ((member? (car items) (cdr items)) false)
        (else (distinct? (cdr items)))))

(define (multiple-dwelling)
  (let ((baker (amd 1 2 3 4 5))
        (cooper (amd 1 2 3 4 5))
        (fletcher (amd 1 2 3 4 5))
        (miller (amd 1 2 3 4 5))
        (smith (amd 1 2 3 4 5)))
    (require (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 1)))
    (require (not (= fletcher 5)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- cooper fletcher)) 1)))
    (list ('baker baker)
          ('cooper cooper)
          ('fletcher fletcher)
          ('miller miller)
          ('smith smith))))

;; Parsing natural language

(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))

;; (sentence (noun-phrase (article the) (noun cat))
;;           (verb eats))

(define (parse-sentence)
  (list 'sentence
        (parse-noun-phrase)
        (parse-word verbs)))

(define (parse-noun-phrase)
  (list 'noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

(define *unparsed* '())
(define (parse input)
  (set! *unparsed* input)
  (let ((sent (parse-sentence)))
    (require (null? *unparsed*))
    sent))


;; (parse '(the cat eats))
;; => (sentence (noun-phrase (article the) (noun cat)) (verb eats))

(define prepositions '(prep for to in by with))

(define (parse-prepositional-phrase)
  (list 'prep-phrase
        (parse-word prepositions)
        (parse-noun-phrase)))

(define (parse-sentence)
  (list 'sentence (parse-noun-phrase) (parse-verb-phrase)))

(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
          (list 'verb-phrase
                verb-phrase
                (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs)))


;; ex
;; '(sleeps in the class)
;; (parse-verb-phrase)
;; ->
;;  sequence: (maybe-extend '(verb sleeps))
;;  *unparsed*: '(in the class)
;;
;; ->
;;  sequence: (amd '(verb sleeps)
;;                 (maybe-extend
;;                   (list 'verb-phrase
;;                         '(verb sleeps)
;;                         (list 'prep-phrase '(prep in) '(article the) '(noun class)))))
;;  *unparsed*: '()
;;
;; ->
;;;; At the next recursion, (parse-prepositional-phrase) results in '(amb) -> fail
;;
;;  sequence: (amd '(verb sleeps)
;;                 (amb
;;                   (list 'verb-phrase
;;                         '(verb sleeps)
;;                         (list 'prep-phrase '(prep in) '(article the) '(noun class)))))
;;  *unparsed*: '()

(define (parse-simple-noun-phrase)
  (list 'simple-noun-phrase
        (parse-word articles)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend
          (list 'noun-phrase
                noun-phrase
                (parse-prepositional-phrase)))))
  (maybe-extend (parse-simple-noun-phrase)))

;; (parse '(the student with the cat sleeps in the class))
;; (sentence (noun-phrase
;;            (simple-noun-phrase (article the) (noun student))
;;            (prep-phrase
;;             (prep with)
;;             (simple-noun-phrase (article the) (noun cat))))
;;           (verb-phrase
;;            (verb sleeps)
;;            (prep-phrase
;;             (prep in)
;;             (simple-noun-phrase (article the) (noun class)))))

;; (parse '(the professor lectures to the student with the cat))
;; (sentence (simple-noun-phrase (article the) (noun professor))
;;           (verb-phrase
;;            (verb-phrase
;;             (verb lectures)
;;             (prep-phrase
;;              (prep to)
;;              (simple-noun-phrase (article the) (noun student))))
;;            (prep-phrase
;;             (prep with)
;;             (simple-noun-phrase (article the) (noun cat)))))

;; (sentence (simple-noun-phrase (article the) (noun professor))
;;           (verb-phrase
;;            (verb lectures)
;;            (prep-phrase
;;             (prep to)
;;             (noun-phrase (simple-noun-phrase (article the) (noun student))
;;                          (prep-phrase
;;                           (prep with)
;;                           (simple-noun-phrase (article the) (noun cat)))))))
