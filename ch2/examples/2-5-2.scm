(define (install-complex-package)
  ;; install the following in the table using tag '(complex scheme-number)
  (define (add-complex-to-schemenum z x)
    (make-from-real-img (+ (real-part z) x)
			(imag-part z)))

  (put 'add '(complex scheme-number)
       (lambda (z x) (tag (add-complex-to-schemenum z x))))
  'done)



