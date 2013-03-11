(define (equ? x y) (apply-generic 'equ? x y))
(define (install-scheme-number-package)
  ;;...
  (define (equ? x y) (= x y))
  (put 'equ? '(scheme-number scheme-number)
       (lambda (x y) (equ? x y)))
  'done)

(define (install-rational-package)
  ;; ...
  (define (equ? x y)
    (and (= (* (numer x) (denom y))
	    (* (denom x) (numer y)))))
  (put 'equ? '(rational rational)
       (lambda (x y) (equ? x y)))
  'done)

(define (install-complex-package)
  ;; ...
  (define (equ? x y)
    (and (= (real-part x) (real-part y))
	 (= (imag-part x) (imag-part y))))
  (put 'equ? '(complex complex)
       (lambda (x y) (equ? x y)))
  'done)

