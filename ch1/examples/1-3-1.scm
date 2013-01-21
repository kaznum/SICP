(define (sum-integers a b)
  (if (> a b)
      0
      (+ a (sum-integers (+ a 1) b))))

(sum-integers 10 12)
(sum-integers 11 13)

(define (cube a)
  (* a a a))
(define (sum-cubes a b)
  (if (> a b)
      0
      (+ (cube a) (sum-cubes (+ a 1) b))))

(sum-cubes 10 12)


(define (pi-sum a b)
  (if (> a b)
      0
      (+ (/ 1.0 (* a (+ a 2))) (pi-sum (+ a 4) b))))

(pi-sum 1 100000)
(/ 3.141592 8)


(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
         (sum term (next a) next b))))

(define (inc n) (+ n 1))

;; 1^3 + 2^3 + 3^3+ ...
(define (sum-cubes a b)
  (sum cube a inc b))

(sum-cubes 10 12)
(sum-cubes 1 10)

;; 1 + 2 + 3 + 4 + ....
(define (identity x) x)

(define (sum-integers a b)
  (sum identity a inc b))
(sum-integers 1 10)

;; pi/8 =  1/(1 * 3) + 1/(5 * 7) + 1/(9 * 11) + ...
(define (pi-sum a b)
  (define (pi-term x)
    (/ 1.0 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))

(* 8 (pi-sum 1 1000))

;; integral
(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2.0)) add-dx b) dx))

(integral cube 0 1 0.01)
(integral cube 0 1 0.001)
(integral cube 0 1 0.0001)

