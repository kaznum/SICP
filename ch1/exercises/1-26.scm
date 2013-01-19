;; the number of evaluation of 'expmod' 2 times for each step because the applicative order evaluation happens

;; exp    n .... 8 4 2 1
;;        ^^^^^^^^^^^^^^
;; count    log(n)/log2 

;; exp    n  (n/2 n/2) (n/4 n/4 n/4 n/4) .... (4 4 ... 4) (2 2 ... 2) (1 1 ....... 1)
;;        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;; count  1 + 2        + 4                 ....                      + 2^(log(n)/log2)

;; [summation(2^n) from 0 to log(n)/log(2)] = (1 - 2^(log(n)/log(2)))/1 - 2 = n
;; So the Order of growth is "theta(n)"
 
