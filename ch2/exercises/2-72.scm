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


(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge tree)
  (if (null? (cdr tree))
      (car tree)
      (successive-merge  (adjoin-set (make-code-tree (car tree) (cadr tree)) (cddr tree)))))

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))

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

;; Answer
;; The number of steps for the most frequent alphabet is 1, that is O(1)
;; That for the least frequest alphabet is n - 1, that is O(n).
;; When the frequency and the number of kinds of symbols is balanced, 
;; Order of growth of the step is 1 + 2 + ..... + n = n/2 * (n+1) ~ O(n^2)

