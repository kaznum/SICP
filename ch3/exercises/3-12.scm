(define (append x y)
  (if (null? x)
      y
      (cons (car x) (append (cdr x) y))))

(define (append! x y)
  (set-cdr! (last-pair x) y)
  x)

(define (last-pair x)
  (if (null? (cdr x))
      x
      (last-pair (cdr x))))

(define x (list 'a 'b))
(define y (list 'c 'd))

(define z (append x y))

z
(cdr x)
;; '(b)

     +---+---+     +---+---+
x -->| * | *-+---> | * |nil|
     +-|-+---+     +-|-+---+
       V             V      
     +---+         +---+ 
     | a |         | b | 
     +---+         +---+ 

     +---+---+     +---+---+
y -->| * | *-+---> | * |nil|
     +-|-+---+     +-|-+---+
       V             V      
     +---+         +---+ 
     | c |         | d | 
     +---+         +---+ 

     +---+---+     +---+---+    +---+---+     +---+---+
z -->| * | *-+---> | * | *-+--->| * | *-+---> | * |nil|
     +-|-+---+     +-|-+---+	+-|-+---+     +-|-+---+
       V             V      	  V             V   
     +---+         +---+ 	+---+         +---+ 
     | a |         | b | 	| c |         | d | 
     +---+         +---+ 	+---+         +---+ 
				

(define w (append! x y))
w

(cdr x)
;; '(b c d)

                                  y
                                  |
                                  V
     +---+---+     +---+---+    +---+---+     +---+---+
x -->| * | *-+---> | * | *-+--->| * | *-+---> | * |nil|
w -->+-|-+---+     +-|-+---+	+-|-+---+     +-|-+---+
       V             V      	  V             V   
     +---+         +---+ 	+---+         +---+ 
     | a |         | b | 	| c |         | d | 
     +---+         +---+ 	+---+         +---+ 


