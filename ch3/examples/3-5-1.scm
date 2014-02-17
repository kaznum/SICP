(define x (cons-stream 'x 'y))

(stream-car x)
;; x
(stream-cdr x)
;; y

stream-ref
stream-map
stream-for-each

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x) (newline) (display x))

(define y (cons 'x (delay 'y)))
(car y)
;; x
(cdr y)
;; #[promise 7]
(stream-car y)
;; x
(stream-cdr y)
;; y
(force (cdr y))
;; y

;;; The stream implementation in action

;; to be continued
