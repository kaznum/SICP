(define (display-line x)
  (newline)
  (display x))

(define (display-stream s)
  (stream-for-each display-line s))

(define (show x)
  (display-line x)
  x)

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define sum 0)
(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq
  (stream-map accum
	      (stream-enumerate-interval 1 20)))
;; sum: 1

(define y (stream-filter even? seq))
;; sum: 6 (1 + 2 + 3)

(define z
  (stream-filter (lambda (x) (= (remainder x 5) 0))
		 seq))
;; sum: 10  (1 + 2 + 3 + 4)

(stream-ref y 7)
;; sum: 136 (1 + 2 + ... + 16)

(display-stream z)
;; sum: 210 (1 + 2 + ... + 20)
;; output to console
;; 10
;; 15 (..5)
;; 45 (..9)
;; 55 (..10)
;; 105 (..14)
;; 120 (..15)
;; 190 (..19)
;; 210 (..20)


;; If delay and force don't use the cached results,
;; each evaluation applies from the first value (1) to the aimed value but 'sum' is not initialized and 'sum' becomes larger than we expect.

