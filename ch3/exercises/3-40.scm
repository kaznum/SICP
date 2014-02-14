(define x 10)
(parallel-execute (lambda () (set! x (* x x)))
		  (lambda () (set! x (* x x x))))

;; The atomic processes are as follows
;; P1:
;; a. access x(1)
;; b. access x(2)
;; c. multiply x
;; d. set! x

;; P2:
;; e. access x(1)
;; f. access x(2)
;; g. access x(3)
;; h. multiply x
;; i. set! x

;; ;; 10^2(minimum)
;; ... -> a -> ... -> b -> ... i ... -> d = 100

;; ;; 10^3
;; ... -> e -> ... -> f -> ... -> g -> ... -> d -> ... ->i = 1000

;; ;; 10 * 10 * 100
;; ... -> e -> ... -> f -> ... -> d -> ... -> g -> h -> i = 10000

;; ;; 10 * 100 * 100
;; ... -> e -> ... -> d -> ... -> f -> g -> h -> i = 100000

;; ;; 100 * 100 * 100 (maximum)
;; ... -> d -> e -> f -> g -> h -> i = 1000000
;; ;; 1000 * 1000 (maximum)
;; e -> f -> g -> h -> i -> a -> .. -> d = 1000000

;; The possible answers are 100, 1000, 10000, 100000, 1000000


(define x 10)
(define s (make-serializer))
(parallel-execute (s (lambda () (set! x (* x x))))
                  (s (lambda () (set! x (* x x x)))))

;; The atomic processes are as follows
;; P1: (lambda () (set! x (* x x)))
;; P2: (lambda () (set! x (* x x x)))

;; P1 -> P2 : 100 * 100 * 100 = 1000000
;; P2 -> P1 : 1000 * 1000 = 1000000

;; So the number of possible answer is one and the answer is 1000000
