;;;; Why.
;; `(live-near ?person-1 ?person-2)` searches the full-set of addresses for ?person-1 and ?person-2 separately.


;;;; The way to find them only once.
(rule (live-near ?person-1 ?person-2)
      (address ?person-1 (?town . ?rest-1))
      (address ?person-2 (?town . ?rest-2))
      (not (same ?person-1 ?person-2)))

(define pairs '())

(rule (in-pairs ?p1 ?p2)
      (lisp-value
       (if (member (cons ?p2 ?p1) pairs)
           #t
           (begin
             (set! (cons (cons ?p1 p2) pairs))
             #f))))

(rule (live-near-unique ?person-1 ?person-2)
      (and (live-near ?person-1 ?person-2)
           (not (in-pairs ?person-1 ?person-2))))

