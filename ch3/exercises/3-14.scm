;; Given in this exercise
(define (mystery x)
  (define (loop x y)
    (if (null? x)
	y
	(let ((temp (cdr x)))
	  (set-cdr! x y)
	  (loop temp x))))
  (loop x '()))


;; mystery reverses the list of the argument.

(define v (list 'a 'b 'c 'd))

     +---+---+     +---+---+     +---+---+     +---+---+
v -->| * | *-+---> | * | *-+---> | * | *-+---> | * |nil|
     +-|-+---+     +-|-+---+     +-|-+---+     +-|-+---+
       V             V             V             V
     +---+         +---+         +---+         +---+
     | a |         | b |         | c |         | d |
     +---+         +---+         +---+         +---+

(define w (mystery v))
  w                                        v
  |	  	  	                   |
  V	  	  	                   V
+---+---+     +---+---+     +---+---+    +---+---+
| * | *-+---> | * | *-+---> | * | *-+--->| * |nil|
+-|-+---+     +-|-+---+     +-|-+---+    +-|-+---+
  V             V             V            V            V
+---+         +---+         +---+        +---+
| d |         | c |         | b |        | a |
+---+         +---+         +---+        +---+

v
;;(a)
w
;;(d c b a)
