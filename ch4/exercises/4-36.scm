;; 1.
;; If there is no upper bound, one of the length of sides does not change from the minimum value forever.

;; 2.
;; The alternatives of the two of three sides should be limitted under the other length

;; from text
(define (an-integer-starting-from n)
  (amb n (an-integer-starting-from (+ n 1))))

;; for solution
(define (an-integer-between n max)
  (require (> max n))
  (amb n (an-integer-between (+ n 1) max)))

(define (a-pythagorean-triple-from low)
  (let ((i (an-integer-starting-from low)))  ;; only the first one is not limitted
    (let ((j (an-integer-between low i)))
      (let ((k (an-integer-between low j)))
        (require (and (= (+ (* i i) (* j j)) (* k k))
        (list i j k)))))))


