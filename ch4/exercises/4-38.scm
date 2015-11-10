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
    ;; The following condition is omitted in this exercise 4.38
    ;; (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- cooper fletcher)) 1)))
    (list ('baker baker)
          ('cooper cooper)
          ('fletcher fletcher)
          ('miller miller)
          ('smith smith))))

;; The original answer of text
;; ((baker 3) (cooper 2) (fletcher 4) (miller 5) (smith 1))
;; The additional solutions of ex4.38 are...

;; (require (not (= baker 5)))
;; -> b: 1 2 3 4
;; -> c: 1 2 3 4 5
;; -> f: 1 2 3 4 5
;; -> m: 1 2 3 4 5
;; -> s: 1 2 3 4 5
;; (require (not (= cooper 1)))
;; -> b: 1 2 3 4
;; -> c: 2 3 4 5
;; -> f: 1 2 3 4 5
;; -> m: 1 2 3 4 5
;; -> s: 1 2 3 4 5

;; (require (not (= fletcher 1)))
;; -> b: 1 2 3 4
;; -> c: 2 3 4 5
;; -> f: 2 3 4 5
;; -> m: 1 2 3 4 5
;; -> s: 1 2 3 4 5

;; (require (not (= fletcher 5)))
;; -> b: 1 2 3 4
;; -> c: 2 3 4 5
;; -> f: 2 3 4
;; -> m: 1 2 3 4 5
;; -> s: 1 2 3 4 5

;; (require (> miller cooper))

;; -> (miller, cooper): (3, 2), (4, 2), (5, 2), (4, 3), (5, 3) (5, 4)

;; -> b: 1 2 3 4
;; -> m, c: (3, 2), (4, 2), (5, 2), (4, 3), (5, 3) (5, 4)
;; -> f: 2 3 4
;; -> s: 1 2 3 4 5

;; (require (not (= (abs (- cooper fletcher)) 1))) (and distinct)
;; -> b: 1 2 3 4
;; -> f, m, c: (4, 3, 2)
;;             (4, 5, 2)
;;             (2, 5, 4)
;; -> s: 1 2 3 4 5

;; (require (distinct? (list baker cooper fletcher miller smith)))

;; (b, f, m, c, s): (1,4,3,2,5), (1,4,5,2,3), (1,2,5,4,3)  # b = 1
;;                : # b = 2
;;                : (3,4,5,2,1), (3,2,5,4,1) # b = 3
;;                : # b = 4

;; The answer has 5 patterns
;; (b, f, m, c, s):
;;   (1,4,3,2,5), (1,4,5,2,3), (1,2,5,4,3)
;;   (3,4,5,2,1), (3,2,5,4,1)
