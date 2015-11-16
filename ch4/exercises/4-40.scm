;; The text version
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)) (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5)) (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (require
     (distinct? (list baker cooper fletcher miller smith)))
    (require (not (= baker 5)))
    (require (not (= cooper 1)))
    (require (not (= fletcher 5)))
    (require (not (= fletcher 1)))
    (require (> miller cooper))
    (require (not (= (abs (- smith fletcher)) 1)))
    (require (not (= (abs (- fletcher cooper)) 1)))
    (list (list 'baker baker) (list 'cooper cooper)
          (list 'fletcher fletcher) (list 'miller miller)
          (list 'smith smith))))

;; Before the 'distinct?', the count of all possibles are 5**5 (= 3125) patterns and
;; after it, they are 5*4*3*2*1 (= 120) patterns.


;; The efficient version by 'let'
(define (multiple-dwelling)
  (let ((baker (amb 1 2 3 4 5)) (cooper (amb 1 2 3 4 5))
        (fletcher (amb 1 2 3 4 5)) (miller (amb 1 2 3 4 5))
        (smith (amb 1 2 3 4 5)))
    (let ((fletcher (amb 1 2 3 4 5)))
      (require (and (not (= fletcher 5))
                    (not (= fletcher 1))))
      (let ((cooper (amb 1 2 3 4 5)))
        (require (and (not (= cooper 1))
                      (not (= (abs (- fletcher cooper)) 1))))
        (let ((miller (amb 1 2 3 4 5)))
          (require (> miller cooper))
          (let ((baker (amb 1 2 3 4 5)))
            (require (not (= baker 5)))
            (let ((smith (amb 1 2 3 4 5)))
              (and (require (not (= (abs (- smith fletcher)) 1))
                            (distinct? (list baker cooper fletcher miller smith))))
              (list (list 'baker baker) (list 'cooper cooper)
                    (list 'fletcher fletcher) (list 'miller miller)
                    (list 'smith smith)))))))))
