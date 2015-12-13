"The professor lectures to the student in the class with the cat."

;; 1.
(sentence (simple-noun-phrase (article the)
                              (noun professor))
          (verb-phrase
            (verb-phrase
             (verb-phrase (verb lectures)
                          (prep-phrase (prep to)
                                       (simple-noun-phrase (article the) (noun student))))
             (prep-phrase (prep in)
                          (simple-noun-phrase (article the) (noun class))))
            (prep-phrase (prep with)
                         (simple-noun-phrase (article the) (noun cat)))))

;; 'to the student' explains 'lectures'
;; 'in the class' explains 'lectures to the student'
;; 'with the cat' explains 'lectures to the student in the class'

;; 2.

(sentence (simple-noun-phrase (article the)
                              (noun professor))
          (verb-phrase
           (verb-phrase (verb lectures)
                        (prep-phrase (prep to)
                                     (simple-noun-phrase (article the) (noun student))))
           (prep-phrase (prep in)
                        (noun-phrase (simple-noun-phrase (article the) (noun class))
                                     (prep-phrase (prep with)
                                                  (simple-noun-phrase (article the) (noun cat)))))))

;; 'to the student' explains 'lectures'
;; 'in the class' explains 'lectures'
;; 'with the cat' explains 'the class'

;; 3.

(sentence (simple-noun-phrase (article the)
                              (noun professor))
          (verb-phrase
           (verb-phrase (verb lectures)
                        (prep-phrase (prep to)
                                     (noun-phrase (simple-noun-phrase (article the) (noun student))
                                                  (prep-phrase (prep in)
                                                               (simple-noun-phrase
                                                                (article the)
                                                                (noun class))))))
           (prep-phrase (prep with)
                        (simple-noun-phrase (article the) (noun cat)))))

;; 'to the student' explains 'lectures'
;; 'in the class' explains 'the student'
;; 'with the cat' explains 'lectures'

;; 4.
(sentence (simple-noun-phrase (article the)
                              (noun professor))
          (verb-phrase
           (verb lectures)
           (prep-phrase
            (prep to)
            (noun-phrase (simple-noun-phrase (article the) (noun student))
                         (prep-phrase (prep in)
                                      (noun-phrase
                                       (noun-phrase
                                        (simple-noun-phrase (article the) (noun class)))
                                       (prep-phrase (prep with)
                                                    (simple-noun-phrase (article the) (noun cat)))))))))

;; 'to the student' explains 'lectures'
;; 'in the class' explains 'the student'
;; 'with the cat' explains 'the class'

;; 5.
(sentence (simple-noun-phrase (article the)
                              (noun professor))
          (verb-phrase
           (verb lectures)
           (prep-phrase
            (prep to)
            (noun-phrase
             (noun-phrase (simple-noun-phrase (article the) (noun student))
                          (prep-phrase (prep in)
                                       (simple-noun-phrase (article the) (noun class))))
             (prep-phrase (prep with)
                          (simple-noun-phrase (article the) (noun cat)))))))


;; 'to the student' explains 'lectures'
;; 'in the class' explains 'the student'
;; 'with the cat' explains 'the student'
