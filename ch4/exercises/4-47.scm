;;;; FROM text
(define (parse-word word-list)
  (require (not (null? *unparsed*)))
  (require (memq (car *unparsed*) (cdr word-list)))
  (let ((found-word (car *unparsed*)))
    (set! *unparsed* (cdr *unparsed*))
    (list (car word-list) found-word)))

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

;; this is replaced in ex4.47
(define (parse-verb-phrase)
  (define (maybe-extend verb-phrase)
    (amb verb-phrase
         (maybe-extend
          (list 'verb-phrase
                verb-phrase
                (parse-prepositional-phrase)))))
  (maybe-extend (parse-word verbs))

;;;; FROM ex4.47
;; (replaces 'parse-verb-phrase)
(define (parse-verb-phrase)
  (amb (parse-word verbs)
       (list 'verb-phrase
             (parse-verb-phrase)
             (parse-prepositional-phrase))))

;;;; Answer

;; 1.

;; Scheme is normally evaluated by applicative-order instead of normal-order,
;; then (parse-word verbs) of the arguments of 'amb' replaces *unparsed*
;; even if the other alternative was selected, which means that
;; there is already no verb when (parse-verb-phrase) in the other alternative is evaluated.
;; This does not work well.

;; 2.

;; If 'amb' evaluation order is interchanged, and '(the cat sleeps in the bed) is applied,
;; The verb-phrase becomes infinite loop
;; (amd (parse-word verbs)
;;      (list 'verb-parse
;;            (amb (parse-word verbs)
;;                 (list 'verb-phrase
;;                       (amb (parse-word verbs)
;;                            (list 'verb-phrase
;;                                  (amb (parse-word verbs)
;;                                       (list 'verb-phrase
;;                                             (amb .....).....



