;; Given
(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))
(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
	right
	(append (symbols left) (symbols right))
	(+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))

(define (decode bits tree)
  (define (decode-1 bits current-branch)
    (if (null? bits)
	'()
	(let ((next-branch
	       (choose-branch (car bits) current-branch)))
	  (if (leaf? next-branch)
	      (cons (symbol-leaf next-branch) (decode-1 (cdr bits) tree))
	      (decode-1 (cdr bits) next-branch)))))
  (decode-1 bits tree))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
	((= bit 1) (right-branch branch))
	(else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((< (weight x) (weight (car set))) (cons x set))
	(else (cons (car set)
		    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
	(adjoin-set (make-leaf (car pair)
			       (cadr pair))
		    (make-leaf-set (cdr pairs))))))


(define sample-tree
  (make-code-tree (make-leaf 'A 4)
		  (make-code-tree
		   (make-leaf 'B 2)
		   (make-code-tree (make-leaf 'D 1)
				   (make-leaf 'C 1)))))


(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))
(decode sample-message sample-tree)
;; (adabbca)

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))

;; Answer
(define (symbol-exist? symbol tree)
  (define (exist? symbol lst)
    (cond ((null? lst) false)
	  ((equal? (car lst) symbol) true)
	  (else (exist? symbol (cdr lst)))))
  (exist? symbol (symbols tree)))

(define (encode-symbol symbol tree)
  (cond ((and (leaf? tree) (equal? symbol (symbol-leaf tree)))
	 '())
	((symbol-exist? symbol (left-branch tree))
	 (cons 0 (encode-symbol symbol (left-branch tree))))
	((symbol-exist? symbol (right-branch tree))
	 (cons 1 (encode-symbol symbol (right-branch tree))))
	(else (error "No such a symbol:" symbol))))
  
;; TEST
(symbol-exist? 'A sample-tree)
(symbol-exist? 'C sample-tree)
(symbol-exist? 'X sample-tree)

(encode-symbol 'A sample-tree)
(encode-symbol 'B sample-tree)
(encode-symbol 'C sample-tree)
(encode-symbol 'D sample-tree)
(encode-symbol 'E sample-tree)

(encode '(a d a b b c a) sample-tree)
;;(0 1 1 0 0 1 0 1 0 1 1 1 0)

(encode (decode '(0 1 1 0 0 1 0 1 0 1 1 1 0) sample-tree) sample-tree)
(decode (encode '(a d a b b c a) sample-tree) sample-tree)

