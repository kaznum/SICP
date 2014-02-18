;; 1
;; 2 (1 + 1)
;; 4 (2 + 2)
;; 8 (4 + 4)
;; 16 (8 + 8)

;; a element is the double of the previous one
;; This is 2^n (n > 0; n is integer)

;; test
(define (add-streams s1 s2) (stream-map + s1 s2))
(define s (cons-stream 1 (add-streams s s)))

(stream-ref s 0)
;; 1
(stream-ref s 1)
;; 2
(stream-ref s 2)
;; 4
(stream-ref s 3)
;; 8
(stream-ref s 4)
;; 16





