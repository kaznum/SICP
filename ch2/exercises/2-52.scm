;; a (add face (eyes and mouth))
(define (wave frame)
  ((segments->painter (list
		       ;;;; face
		       (make-segment (make-vect 0.33 0.1 (make-vect 0.35 0.1)))
		       (make-segment (make-vect 0.67 0.1 (make-vect 0.65 0.1)))
		       (make-segment (make-vect 0.45 0.35 (make-vect 0.55 0.35)))
                       ;; leftside
                       ;;;; head
                       (make-segment (make-vect 0.4 0) (make-vect 0.3 0.2))
                       (make-segment (make-vect 0.3 0.2) (make-vect 0.4 0.4))
                       ;;;; shoulder
                       (make-segment (make-vect 0.4 0.4) (make-vect 0.3 0.4))
                       ;;;; arm-top
                       (make-segment (make-vect 0.3 0.4) (make-vect 0.15 0.45))
                       (make-segment (make-vect 0.15 0.45) (make-vect 0 0.2))
                       ;;;; arm-bottom
                       (make-segment (make-vect 0 0.4) (make-vect 0.15 0.65))
                       (make-segment (make-vect 0.15 0.65) (make-vect 0.3 0.45))
                       (make-segment (make-vect 0.3 0.5) (make-vect 0.35 0.5))
                       ;; leg-outside
                       (make-segment (make-vect 0.35 0.5) (make-vect 0.2 1.0))
                       ;; leg-inside
                       (make-segment (make-vect 0.35 0.5) (make-vect 0.2 1.0))
                       ;;;; leg-inside
                       (make-segment (make-vect 0.5 0.7) (make-vect 0.4 1.0))
                       ;; rightside
                       ;;;; head
                       (make-segment (make-vect 0.6 0) (make-vect 0.7 0.2))
                       (make-segment (make-vect 0.7 0.2) (make-vect 0.6 0.4))
                       ;;;; shoulder
                       (make-segment (make-vect 0.6 0.4) (make-vect 0.7 0.4))
                       ;;;; arm-top
                       (make-segment (make-vect 0.7 0.4) (make-vect 1.0 0.6))
                       ;;;; arm-bottom
                       (make-segment (make-vect 1.0 0.8) (make-vect 0.6 0.5))
                       ;;;; leg-outside
                       (make-segment (make-vect 0.6 0.5) (make-vect 0.8 1.0))
                       ;;;; leg-inside
                       (make-segment (make-vect 0.5 0.7) (make-vect 0.6 1.0))))
   
   frame))

;; b
(define (corner-split painter n)
  (if (= n 0)
      painter
      (let ((up (up-split painter (- n 1)))
            (right (right-split painter (- n 1))))
        (let ((top-left up)
              (bottom-right right)
              (corner (corner-split painter (- n 1))))
          (beside (below painter top-left)
                  (below bottom-right corner))))))

;; c
(define (square-limit painter n)
  (let ((combine4 (square-of-four flip-horiz identity
                                  rotate180 flip-vert)))
    (combine4 (corner-split (flip-horiz painter) n))))

