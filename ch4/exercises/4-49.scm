;; From text
(define nouns '(noun student professor cat class))
(define verbs '(verb studies lectures eats sleeps))
(define articles '(article the a))
(define prepositions '(prep for to in by with))

(define (parse-sentence)
  (list 'sentence
        (parse-noun-phrase)
        (parse-word verbs)))

;;;; not used in this solution
;; (define *unparsed* '())
;; (define (parse input)
;;   (set! *unparsed* input)
;;   (let ((sent (parse-sentence)))
;;     (require (null? *unparsed*))
;;     sent))


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

;;;; original from text
;; (define (parse-word word-list)
;;   (require (not (null? *unparsed*)))
;;   (require (memq (car *unparsed*) (cdr word-list)))
;;   (let ((found-word (car *unparsed*)))
;;     (set! *unparsed* (cdr *unparsed*))
;;     (list (car word-list) found-word)))

;; Answer
;;;; once a word selected, the word is appended to the list of the words to rotate the word-list
(define (rotate-word-list word-list)
  (let ((type (car word-list))
        (word (car (cdr word-list))))
    (append (list type) (append (cdr (cdr word-list)) (list word)))))

(define (parse-word word-list)
  (let ((type (car word-list))
        (word (car (cdr word-list))))
    (cond
     ((eq? type 'noun) (set! nouns (rotate-word-list nouns)))
     ((eq? type 'verb) (set! verbs (rotate-word-list verbs)))
     ((eq? type 'article) (set! articles (rotate-word-list articles)))
     ((eq? type 'preposition) (set! prepositions (rotate-word-list prepositions))))
    (list type word)))

;; Imaginary TEST
;; Scheme deals with the argument by applicative order then all of the arguments in (amb ...) is processed forcefully.

;;;; 1.
;; word-list state
nouns = '(noun student professor cat class)
verbs = '(verb studies lectures eats sleeps)
articles = '(article the a)
prepositions = '(prep for to in by with)

;; generated sentence
the student studies
the student for a professor studies
the student for a professor studies to the cat


;;;; 2.
;; word-list state
nouns = '(noun class student professor cat)
verbs = '(verb lectures eats sleeps studies)
articles = '(article the a)
prepositions = '(prep in by with for to)

;; generated sentence
the class lectures
the class in a student lectures
the class in a student lectures by the professor

