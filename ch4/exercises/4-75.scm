(load "../examples/4-4-4-1")
(load "../examples/4-4-4-2")
(load "../examples/4-4-4-3")
(load "../examples/4-4-4-4")
(load "../examples/4-4-4-5")
(load "../examples/4-4-4-6")
(load "../examples/4-4-4-7")
(load "../examples/4-4-4-8")


;;;; Answer

(define (unique-asserted pattern frame-stream)
  (define unique-frames the-empty-stream)
  (define (equal-frame? f1 f2)
    (if (and (null? f1) (null? f2))
        true
        (let ((binding (car f1)))
          (let ((var (binding-variable binding))
                (val (binding-value binding))
                (frame-in-f2 (binding-in-frame var f2)))
            (cond ((not frame-in-f2) false)
                  ((equal? val (binding-value frame-in-f2))

                   ...)


                  (else false))))))
  (define (accumulate-unique-frames frame frames)
    (cond ((stream-null? frames)
           (cons-stream frame frames))
          ((equal? (stream-car frames) frame)
           (stream-cdr frames))
          (else
           (stream-cons (stream-car frames)
                        (accumulate-unique-frames frame (stream-cdr frames))))))
  (stream-flatmap
   (lambda (frame)
     (set! unique-frames (accumulate-unique-frames frame unique-frames)))
   (qeval pattern frame-stream))
  unique-frames)


(put 'unique 'qeval unique-asserted)


;; to be continued
