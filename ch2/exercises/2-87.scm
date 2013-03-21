(put '=zero? 'polynomial
     (lambda (p)
       (define (=zero-terms? terms)
	 (or (empty-termlist? terms)
	     (and (=zero? (coeff (first-term terms)))
		  (=zero-terms? (rest-terms (terms)))))
       (=zero-terms? (term-list p)))))

