;; parallel resistor
(define (par1 r1 r2)
  (div-interval (mul-interval r1 r2)
                (add-interval r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (div-interval one
                  (add-interval (div-interval one r1)
                                (div-interval one r2)))))


;;
;; Right.
;; The par2 has fewer uncertain numbers (par1 has 4 and par2 has 2), that means
;; there are fewer chances to introduce error.
;;
