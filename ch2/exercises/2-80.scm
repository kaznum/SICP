(define (=zero? x) (apply-generic '=zero? x))

(define (install-scheme-number-package)
  ;;...
  (define (=zero? x) (= x 0))
  (put 'equ? '(scheme-number) =zero?)
  'done)

(define (install-rational-package)
  ;; ...
  (define (=zero? x) (= (numer x) 0))
  (put 'equ? '(rational) =zero?)
  'done)

(define (install-complex-package)
  ;; ...
  (define (=zero? x) (= (magnitude x) 0))
  (put '=zero? '(complex) =zero?)
  'done)

