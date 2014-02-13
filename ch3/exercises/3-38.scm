;; a.

;;; Peter -> Paul -> Mary
(define balance 100)
(set! balance (+ balance 10))
(set! balance (- balance 20))
(set! balance (- balance (/ balance 2)))
balance
;;; 45

;;; Peter -> Mary -> Paul
(define balance 100)
(set! balance (+ balance 10))
(set! balance (- balance (/ balance 2)))
(set! balance (- balance 20))
balance
;;; 35

;;; Paul -> Peter -> Mary
(define balance 100)
(set! balance (- balance 20))
(set! balance (+ balance 10))
(set! balance (- balance (/ balance 2)))
balance
;;; 45

;;; Paul -> Mary -> Peter
(define balance 100)
(set! balance (- balance 20))
(set! balance (- balance (/ balance 2)))
(set! balance (+ balance 10))
balance
;;; 50

;;; Mary -> Peter -> Paul
(define balance 100)
(set! balance (- balance (/ balance 2)))
(set! balance (+ balance 10))
(set! balance (- balance 20))
balance
;;; 40

;;; Mary -> Paul -> Peter
(define balance 100)
(set! balance (- balance (/ balance 2)))
(set! balance (- balance 20))
(set! balance (+ balance 10))
balance
;;; 40


;; b.

;;       Peter                    Paul                   Mary

;; Access balance: 100
;;                         Access balance: 100
;; New value: 100+10=110
;;                         New value: 100-20=80
;; set! balance to 110
;;                                                  Access balance: 110
;;                         set! balance to 80
;;                                                  Temp: 110/2=55
;;                                                  Access balance: 80
;;                                                  New balue: 80-55=25
;;                                                  set! balance to 25



;;       Peter                    Paul                   Mary

;; Access balance: 100
;;                         Access balance: 100
;;                         New value: 100-20=80
;;                                                  Access balance: 100
;;                         set! balance to 80
;;                                                  Temp: 100/2=50
;;                                                  Access balance: 80
;;                                                  New value: 80-50=30
;;                                                  set! balance to 30
;; New value: 100+10=110
;; set! balance to 110
