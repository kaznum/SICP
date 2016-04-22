(define (find-assertions pattern frame)
  (stream-flatmap
   (lambda (datum)
     (check-an-assertion datum pattern frame))
   (fetch-assertions pattern frame)))   ;; It is not necessory but for efficiency.

;; return empty stream or the stream of an extended frame.
(define (check-an-assertion assertion query-pat query-frame)
  (let ((match-result
         (pattern-match query-pat assertion query-frame)))
    (if (eq? match-result 'failed)
        the-empty-stream
        (singleton-stream match-result))))


;; return the symbol 'failed or an extension of the given frame.
(define (pattern-match pat dat frame)
  (cond ((eq? frame 'failed) 'failed)  ;; eq?: same data cell in the internal
        ((equal? pat dat) frame)       ;; equal?: same results when evaluated
        ((var? pat) (extend-if-consistent pat dat frame))
        ((and (pair? pat) (pair? dat))
         (pattern-match (cdr pat) (cdr dat)
                        (pattern-match (car pat) (car dat) frame)))
        (else 'failed)))

;; 1 ]=> (eq? "aaa" "aaa")
;; ;Value: #f
;; 1 ]=> (equal? "aaa" "aaa")
;; ;Value: #t
;; 1 ]=> (eq? 'aaa 'aaa)
;; ;Value: #t
;; 1 ]=> (equal? 'aaa 'aaa)
;; ;Value: #t

(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
        (pattern-match (binding-value binding) dat frame)
        (extend var dat frame))))

;; If ?x is bound to (f ?y) in a frame, then dat is (f b), then the binding ?y = b is stored in the extended frame but ?x binding (f ?y) is not modified. We never modify the already bound variables.


;;;; Patterns with dotted tails

;; When `read` in underlying list system encounters dot(.),
;; it makes the next item as cdr of the list structure.
;; For example,
;; the pattern for `(computer ?type)` is structured as `(cons 'computer (cons '?type '()))`
;; on the other hand,
;; (computer . ?type) is structured as `(cons 'computer '?type)`
