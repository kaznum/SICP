;; From text
(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))

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

;; Do not use this function in this exercise
;; (define (parse-simple-noun-phrase)
;;   (list 'simple-noun-phrase
;;         (parse-word articles)
;;         (parse-word nouns)))

;; Do not use this function in this exercise
;; (define (parse-noun-phrase)
;;   (define (maybe-extend noun-phrase)
;;     (amb noun-phrase
;;          (maybe-extend
;;           (list 'noun-phrase
;;                 noun-phrase
;;                 (parse-prepositional-phrase)))))
;;   (maybe-extend (parse-simple-noun-phrase)))

;; Answer ex4.48
;; support adjectives to be followed by a noun
;; they are prepositioned to a noun
(define adjectives '(adjective cute good bad big small))

(define (parse-adjectived-noun-phrase)
  (list 'adjectived-noun-phrase
        (parse-word articles)
        (parse-word adjectives)
        (parse-word nouns)))

(define (parse-noun-phrase)
  (define (maybe-extend noun-phrase)
    (amb noun-phrase
         (maybe-extend
          (list 'noun-phrase
                noun-phrase
                (parse-prepositional-phrase)))))

  (define (adjective-noun-phrase article pre-adjectives)
    (amb (list 'adjectived-noun-phrase article
               (list 'adjectives pre-adjectives)
               (parse-word nouns))
         (adjective-noun-phrase article
                                (append pre-adjectives
                                        (list (parse-word adjectives))))))

  (define (parse-simple-or-adjectived-noun-phrase article)
    (amb (list 'simple-noun-phrase article (parse-word noun))
         (adjective-noun-phrase article '())))

  (maybe-extend (parse-simple-or-adjectived-noun-phrase (parse-word article))))



;; support adverbs to be followed by a verb
;; they are prepositioned to a verb
(define adverbs '(adverb finally rapidly occasionally)
(define (parse-verb-phrase)
  ...)

;; to be continued
