(define (double f)
  (lambda (x) (f (f x))))

(define (inc x)
  (+ x 1))

((double inc) 4)
((double inc) 8)
(((double (double double)) inc) 5)

(((double (lambda (f) (double (double f)))) inc) 5)
(((lambda (g) ((lambda (f) (double (double f)))
	       ((lambda (f) (double (double f)))
		g)))
  inc) 5)
(((lambda (g) ((lambda (f) (double (double f)))
	       (double (double g))))
  inc) 5)
(((lambda (f) (double (double f)))
  (double (double inc))) 5)
((double (double (double (double inc)))) 5)
((double (double (double (lambda (x) (inc (inc x)))))) 5)
                                      ^^^^^^^^
                                        * 2 times

((double (double (lambda (y) ((lambda (x) (inc (inc x)))
			      ((lambda (x) (inc (inc x)))
			       y))))) 5)
((double (double (lambda (y) (inc (inc ((lambda (x) (inc (inc x)))
					y)))))) 5)

((double (double (lambda (y) (inc (inc (inc (inc y))))))) 5)
                              ^^^^^^^^^^^^^^^^^^
                                  * 2 times (4)

((double (lambda (y) (inc (inc (inc (inc (inc (inc (inc (inc y)))))))))) 5)
                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                  * 2 times (8)
((lambda (y) (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc y))))))))))))))))) 5)
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
                                  * 2 times (16)

(inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc (inc 5))))))))))))))))
;; => 21

