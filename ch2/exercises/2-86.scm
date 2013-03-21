(define (sine x) (apply-generic 'sine x))
(define (cosine x) (apply-generic 'cosine x))

(define (install-scheme-number-package)
  ;; ....
  (put 'sine 'scheme-number
       (lambda (x) (attach-tag 'real (sin x))))
  (put 'cosine 'scheme-number
       (lambda (x) (attach-tag 'real (cos x)))))

(define (install-rational-package)
  ;; ....
  (put 'sine 'rational
       (lambda (x) (attach-tag 'real (sine (/ (numer x) (denom x)))))))

;; use numeric operators which are defined customly
(define (install-complex-package)
  ;;...
  (define (add-complex z1 z2)
    (make-from-real-imag (add (real-part z1) (real-part z2))
                         (add (imag-part z1) (imag-part z2))))
  (define (sub-complex z1 z2)
    (make-from-real-imag (sub (real-part z1) (real-part z2))
                         (sub (imag-part z1) (imag-part z2))))
  (define (mul-complex z1 z2)
    (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                       (add (angle z1) (angle z2))))
  (define (div-complex z1 z2)
    (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                       (sub (angle z1) (angle z2)))))
