(car ''abracadabra)
;; quote

;; This means
(car (quote (quote abracadabra)))
;; and
(car '(quote abracadabra))
;; So the first element in the list is 'quote'

;; And
(cdr (quote (quote abracadabra)))
;; prints '(abracadabra)'

