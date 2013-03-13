(define (convert-as-type lst type)
  (if (null? lst)
      '()
      (let ((converter (get-coercion (type-tag (car lst)) type)))
	(if converter
	    (cons (converter (car lst)) (convert-as-type (cdr lst) type))
	    (cons (car lst) (convert-as-type (cdr lst) type))))))

(define (apply-each-types args types)
  (if (null? types)
      (error "No method")
      (let ((converted-args (convert-as-type args (car types))))
	(let ((type-tags (map type-tag converted-args)))
	  (let ((proc (get op type-tags)))
	    (if proc
		(apply proc (map contents converted-arg))
		(apply-each-types args (cdr types))))))))

(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
    (let ((proc (get op type-tags)))
      (if proc
	  (apply proc (map contents args))
	  (apply-each-types args type-tags)))))

;; In the two arguments case, at first, the second argument is to be converted and find the proc but it may fail, and second, the first argument is to be converted and find the proc but it may fail then all fail.
;; Suppose the following condition,
;; 1. proc is defined with mixed-type arguments type1, type2
;; 2. type3 can be converted to type1
;; When proc is called with type3 and type2 args, this should be processed by converting the type3 arg to type1, but the above procedure cannot handle because the arguments' types are only type3 and type2 and do not try to convert the type3 argument to type1.


