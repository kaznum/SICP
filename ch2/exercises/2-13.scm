;;  I1 = ( a * (1 - t1), b * (1 + t1) )
;;  I2 = ( c * (1 - t2), d * (1 + t2) )
;;     where a < b, c < d and a,b,c,d > 0
;;  (mul-interval I1 I2)
;;    = ((a*(1-t1) * c*(1-t2)), (b*(1+t1) * d*(1+t2)))
;;    = ((a*(1-t1) * c*(1-t2)), (b*(1+t1) * d*(1+t2)))
;;    = (a*c*(1 - (t1+t2) + t1*t2), b*d*(1 + (t1+t2) + t1*t2))
;;    =~ (a*c*(1 - (t1 + t2)), b*d*(1 + (t1 + t2))
;;       because t1, t2 << 1
;;
;;  So, the approximate percentage tollerance of the product of
;;  two intervals is the sum of the tolerance. (t1 + t2)
