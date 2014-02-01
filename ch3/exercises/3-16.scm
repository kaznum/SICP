; Ben's code example does not check whether the object is shared or not.

;; There are three pairs, and the function returns 3
(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
	 (count-pairs (cdr x))
	 1)))

(count-pairs '(x y z))
;Value: 3
;; the diagram
;;
;; +---+---+    +---+---+    +---+---+ 
;; | * | *----->| * | *----->| * | / |
;; +-|-+---+    +-|-+---+    +-|-+---+
;;   |            |            |
;;   v            v            v
;; +-+-+        +-+-+        +-+-+
;; | x |        | y |        | z |
;; +---+        +---+        +---+

;; There are three pairs but the function returns 4
(define p1 (cons 'a 'b))
(count-pairs (cons (cons p1 p1) '()))
;Value: 4
(cons (cons p1 p1) '())
;; (((a . b) (a . b)))

;; diagram  (p1 is a shared pair)
;; +---+---+
;; | * | / |
;; +-|-+---+
;;   |      
;;   v      
;; +---+---+
;; | * | * |
;; +-|-+-|-+
;;   |   |
;;   |   |
;;   |   |   
;;   +---+-------+
;;               |
;;               v
;;             +---+---+    
;;   p1------->| * | *-+---+
;;             +-|-+---+   |
;;               |         |
;;               v         v
;;             +---+     +---+
;;             | a |     | b |
;;             +---+     +---+


;; There are three pairs but the function returns 5
(define p2 '(a))
(cons (cons p2 p2) p2)
;; (((a) a) a)
(count-pairs (cons (cons p2 p2) p2))
;Value: 5

;; diagram  (p2 is a shared pair)
;; +---+---+                 +---+---+
;; | * | *-+------> p2 ----->| * | / |
;; +-|-+---+        ^^       +-|-+---+
;;   |              ||         |
;;   v              ||         v
;; +---+---+        ||       +---+
;; | * | *-+--------+|       | a |
;; +-|-+---+         |       +---+
;;   |               |
;;   +---------------+
;;   

;;;; (extra answer for 'returns 4')
;; There are three pairs but the function returns 4
(define p2 '(a))
(cons (cons 'x p2) p2)
;; ((x a) a)
(count-pairs (cons (cons 'x p2) p2))
;Value: 4

;; diagram  (p2 is a shared pair)
;; +---+---+                +---+---+
;; | * | *-+------> p2 ---->| * | / |
;; +-|-+---+        ^       +-|-+---+
;;   |              |         |
;;   v              |         v
;; +---+---+        |       +---+
;; | * | *-+--------+       | a |
;; +-|-+---+                +---+
;;   |
;;   v
;; +---+  
;; | x |
;; +---+
