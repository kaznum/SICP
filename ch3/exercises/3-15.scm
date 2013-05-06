;; Given in this section
(define x (list 'a 'b))
(define z1 (cons x x))
(define z2 (cons (list 'a 'b) (list 'a 'b)))
(define (set-to-wow! x)
  (set-car! (car x) 'wow)
  x)
(set-to-wow! z1)
;; ((wow b) wow b)
(set-to-wow! z2)
;; ((wow b) a b)

      +---+---+
z1 -->| * | * |
      +-|-+-|-+
        V   V
      +---+---+     +---+---+
 x -->| * | *-+---> | * |nil|
      +-|-+---+     +-|-+---+
        V             V      
      +---+         +---+    
      |wow|         | b |    
      +---+         +---+    

      +---+---+     +---+---+     +---+---+
z2 -->| * | *-+---> | * | *-+---> | * |nil|
      +-|-+---+	    +-|-+---+     +-|-+---+
        |  	      V             V      
	|	    +---+         +---+    
	|	    | a |         | b |    
	|	    +---+         +---+    
        |                           ^
        |                           |
        |           +---+---+     +-|-+---+
        +---------->| * | *-+---> | * |nil|
                    +-|-+---+     +---+---+
                      V
                    +---+
                    |wow|
                    +---+

