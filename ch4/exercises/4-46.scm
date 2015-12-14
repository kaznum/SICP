;; '(the cat sleeps)
;; is parsed as following...

;; (parse '(the cat sleeps))

;; =>

;; (list 'sentence (maybe-extend (parse-simple-noun-phrase)))

;; =>

;; (list 'sentence (amb '(simple-noun-phrase (article the) (noun cat))
;;                      (maybe-extend
;;                       (list 'noun-phrase '(simple-noun-phrase (article the) (noun cat))
;;                             (parse-prepositional-phrase)))))

;; =>

;; (list 'sentence (amb '(simple-noun-phrase (article the) (noun cat))
;;                     (amb '(noun-phrase (simple-noun-phrase (article the) (noun cat))
;;                                        (amb)))))

;; The most right evaluation results in `(amb)`, which means that there is no possible alternative
;; at first.
