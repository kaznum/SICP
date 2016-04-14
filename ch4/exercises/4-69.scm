;; From ex4.63
(son Adam Cain)
(son Cain Enoch)
(son Enoch Irad)
(son Irad Mehujael)
(son Mehujael Methushael)
(son Methushael Lamech)
(wife Lamech Ada)
(son Ada Jabal)
(son Ada Jubal)

(rule ((grandson) ?g ?s)
      (and (son ?f ?s)
           (son ?g ?f)))
(rule (son ?m ?s)
      (or (son ?m ?s)
          (and (wife ?m ?w)
               (son ?w ?s))))
;; Answer
(rule ((great . ?rel) ?x ?y)
      (and (?rel ?x ?u)
           (son ?u ?y)))

;; TEST
((great grandson) ?g ?ggs)
;; frame1: ?rel=(grandson), ?x=?g, ?y=?ggs
;; (rule ((great grandson) ?g ?ggs)
;;       (and ((grandson) ?g ?u)
;;            (son ?u ?ggs)))
;; frame1-ex: ?rel=(grandson), ?x=?g, ?y=?ggs
;;    ((grandson) ?g ?u)
;;    (?g,?u) = (Adam, Enoch), (Cain, Irad) (Enoch, Mehujael), (Irad, Methushael), (Mehujael, Lamech), (Methushael, Jabal), (Methushael, Jubal)
;;    filtered (?g, ?u, ?ggs)
;;       = (Adam, Enoch, Irad),
;;         (Cain, Irad, Mehujael)
;;         (Enoch, Mehujael, Methushael),
;;         (Irad, Methushael, Lamech),
;;         (Mehujael, Lamech, Jabal), (Mehujael, Lamech, Jubal)
;; then result is
;;
;; ((great grandson) Adam Irad)
;; ((great grandson) Cain Mehujael)
;; ((great grandson) Enoch Methushael)
;; ((great grandson) Irad Lamech)
;; ((great grandson) Mehujael Jabal)
;; ((great grandson) Mehujael Jubal)


(?relationship Adam Irad)
(rule ((great . ?rel) ?x ?y)
      (and (?rel ?x ?u)
           (son ?u ?y)))

;; frame1: (?relationship ?x ?y) = ((great . ?rel) Adam Irad)
(rule ((great . ?rel) Adam Irad)
      (and (?rel Adam ?u) ;; *1
           (son ?u Irad)))  ;; *2

;; *1-frame
;;   (?rel ?u) = (son Cain), ((grandson) Enoch), ((great grandson) Irad), ((great great grandson) Mehujael), ((great great great grandson) Methushael), ((great great great great grandson) Lamech), ((great great great great great grandson) Jabal), ((great great great great great grandson) Jubal)
;; *2-frame(filter *1-frame)
;;   (?rel ?u) = ((grandson) Enoch)
;; => ?relationship = (great grandson)
