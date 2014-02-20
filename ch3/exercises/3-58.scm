(define (expand num den radix)
  (cons-stream
   (quotient (* num radix) den)
   (expand (remainder (* num radix) den) den radix)))

;; This is the digits of num/den when num is smaller than den whose cardinal number is radix

;; (expand 1 7 10)
;; 1: (quotient (* 1 10) 7) = 1
;; 2: (expand (remainder (* 1 10) 7) 7 10)
;;    (expand 3 7 10)
;;    (quotient (* 3 10) 7) = 4
;; 3: (expand (remainder (* 3 10) 7) 7 10)
;;    (expand 2 7 10)
;;    (quotient (* 2 10) 7) = 2
;; 4: (expand (remainder (* 2 10) 7) 7 10)
;;    (expand 6 7 10)
;;    (quotient (* 6 10) 7) = 8
;; 5: (expand (remainder (* 6 10) 7) 7 10)
;;    (expand 4 7 10)
;;    (quotient (* 4 10) 7) = 5
;; 6: (expand (remainder (* 4 10) 7) 7 10)
;;    (expand 5 7 10)
;;    (quotient (* 5 10) 7) = 7
;; 7: (expand (remainder (* 5 10) 7) 7 10)
;;    (exapnd 1 7 10) = 1
;; 8: 4
;; 9: 2

(define a1 (expand 1 7 10))
(stream-ref a1 0)
(stream-ref a1 1)
(stream-ref a1 2)
(stream-ref a1 3)
(stream-ref a1 4)
(stream-ref a1 5)
(stream-ref a1 6)
(stream-ref a1 7)
(stream-ref a1 8)


;; (expand 3 8 10)
;; 1: (quotient (* 3 10) 8) = 3
;; 2: (expand (remainder (* 3 10) 8) 8 10)
;;    (expand 6 8 10)
;;    (quotient (* 6 10) 8) = 7
;; 3: (expand (remainder (* 6 10) 8) 8 10)
;;    (expand 4 8 10)
;;    (quotient (* 4 10) 8) = 5
;; 4: (expand (remainder (* 4 10) 8) 8 10)
;;    (expand 0 8 10)
;;    (quotient (* 0 10) 8) = 0
;; 5: (expand (remainder (* 0 10) 8) 8 10)
;;    (expand 0 8 10) = 0
;; 6: 0
;; 7: 0

(define a2 (expand 3 8 10))
(stream-ref a2 0)
(stream-ref a2 1)
(stream-ref a2 2)
(stream-ref a2 3)
(stream-ref a2 4)
(stream-ref a2 5)



