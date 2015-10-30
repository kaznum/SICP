(define (a-pythagorean-triple-between low high)
  (let ((i (an-integer-between low high))
        (hsq (* high high)))
    (let ((j (an-integer-between i high)))
      (let ((ksq (+ (* i i) (* j j))))
        (require (>= hsq ksq))
        (let ((k (sqrt ksq)))
          (require (integer? k))
          (list i j k))))))

;; Answer
;; when low = 1, high = 3,

;; For Ben's code has high^2 = 9 possible alternatives
;; i = 1, j = 1, k = 3
;; i = 1, j = 2, k = 3
;; i = 1, j = 3, k = 3
;; i = 2, j = 2, k = 3
;; i = 2, j = 3, k = 3 (fail at (require (>= hsq ksq)))
;; i = 3, j = 3, k = 3 (fail at (require (>= hsq ksq)))

;; n = 1: 1 = 1
;; n = 2: 2+1 = 3
;; n = 3: 3+2+1 = 6
;; n = n: sum(n) = n*(n+1)/2
;;        f(n) = n**2

;; For ex4-35's code has 10 possible alternatives
;; i = 1, j = 1, k = 1
;; i = 1, j = 1, k = 2
;; i = 1, j = 1, k = 3
;; i = 1, j = 2, k = 2
;; i = 1, j = 2, k = 3
;; i = 1, j = 3, k = 3
;; i = 2, j = 2, k = 2
;; i = 2, j = 2, k = 3
;; i = 2, j = 3, k = 3
;; i = 3, j = 3, k = 3

;; n == 1: 1 = 1
;; n == 2: (2+1)+1 = 4
;; n == 3: (3+2+1)+(2+1)+(1) = 10
;; n == 4: (4+3+2+1)+(3+2+1)+(2+1)+1 = 20
;; n == n: f(n) = f(n-1) + n*(n+1)/2
;;         so, f(n) = (n*(n+1)*(2n+1)/6 + n*(n+1)/2)/2

;; That's why Ben's code is more effective.

