(define memo-fib
  (memoize (lambda (n)
	     (cond ((= n 0) 0)
		   ((= n 1) 1)
		   (else (+ (memo-fib (- n 1))
			    (memo-fib (- n 2))))))))

;;; this is one-dim table which is defined in section 3.3.3
(define (memoize f)
  (let ((table (make-table)))
    (lambda (x)
      (let ((previously-computed-result (lookup x table)))
	(or previously-computed-result
	    (let ((result (f x)))
	      (insert! x result table)
	      result))))))

;; functions are defined
;;              +-------------------------------------------------------+
;;    global--> | memoize --------------------------------------+       |
;;              |                                               |       |
;;              | memo-fib -+                                   |       |
;;              +-----------|-----------------------------------+-------+
;;                          |                 ^                 |     ^
;;                          |                 |                 V     |
;;                          |             +-----------+     +---+---+ |
;;                          |        E1-->|table      |     | * | *-+-+
;;                          |             +-----------+     +-|-+---+
;;                          |                 ^               V
;;                      +---+---+             |         params: f
;;                      | * | *-+-------------+         body: the body of memoize
;;                      +-|-+---+
;;                        |
;;                        V
;;                   params: n
;;                   body: (memoize (lam..

;; (memo-fib 3)
;;             +-------------------------------------------------------+
;;   global--> | memoize --------------------------------------+       |
;;             |                                               |       |
;;             | memo-fib -+                                   |       |
;;             +-----------|-----------------------------------+-------+
;;                         |                 ^                 |     ^
;;                         |                 |                 V     |
;;                         |             +-----------+     +---+---+ |
;;        +-----+          |        E1-->|table      |     | * | *-+-+
;;   E2 ->|x: 3 |----------------------->+-----------+     +-|-+---+
;;        +-----+          |                ^ ^              V
;; call to memo-fib        |                | |             params: f
;;        +-----+          |                | |             body: the body of memoize
;;   E3 ->|x: 2 |---------------------------+ |
;;        +-----+          |                  |
;; call to memo-fib        V                  |
;;   E3,E4->(x:0,1)    +---+---+              |
;; call to memo-fib    | * | *-+--------------+
;;                     +-|-+---+
;;                       |
;;                       V
;;                    params: x
;;                    body: lambda...


;; O(n)
;; When computing (memo-fib n), each of (memo-fib (- n 1)),
;; (memo-fib (- n 2))... called several times, but they are
;; computed only at the first time and after that, the result
;; comes from the cache from the table, so the order is O(n)
;;
;; (define memo-fib (memoize fib))
;; The memoize does not work well because fib calls fib recursively,
;; but the recursive calling of fib is not call with memoize.
;;
