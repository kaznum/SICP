;; Given
;; (define (make-zero-crossings input-stream last-value)
;;   (cons-stream
;;    (sign-change-detector
;;     (stream-car input-stream)
;;     last-value)
;;    (make-zero-crossings
;;     (stream-cdr input-stream)
;;     (stream-car input-stream))))

;; (define zero-crossings
;;   (make-zero-crossings sense-data 0))

;; helpers
(define (stream-map f s1 s2)
  (cons-stream (f (stream-car s1) (stream-car s2))
	       (stream-map f (stream-cdr s1) (stream-cdr s2))))


(define (sign-change-detector a b)
  (cond ((< (* a b) 0)
	 (if (> a b) 1 -1))
	((> (* a b) 0) 0)
	((< a 0) -1)
	((< b 0) 1)
	(else 0)))

;; (sign-change-detector 0 1)
;; (sign-change-detector 1 2)
;; (sign-change-detector 1 0)
;; (sign-change-detector 1 -1)
;; (sign-change-detector -1 1)
;; (sign-change-detector -1 0)
;; (sign-change-detector 0 -1)

(define sense-list (list 1 2 1.5 1 0.5 -0.1 -2 -3 -2 -0.5 0.2 3 4))
(define (make-stream ls)
  (if (null? ls)
      the-empty-stream
      (cons-stream (car ls) (make-stream (cdr ls)))))
(define sense-data (make-stream sense-list))

;; Answer
(define zero-crossings
  (stream-map sign-change-detector
	      sense-data
	      (cons-stream 0 sense-data)))

;; TEST
(show-stream zero-crossings 11)
;; 0
;; 0
;; 0
;; 0
;; 0
;; -1
;; 0
;; 0
;; 0
;; 0
;; 1
