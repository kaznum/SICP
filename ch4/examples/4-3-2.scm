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

;; to be continued
