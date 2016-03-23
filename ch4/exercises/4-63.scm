(son Adam Cain)
(son Cain Enoch)
(son Enoch Irad)
(son Irad Mehujael)
(son Mehujael Methushael)
(son Methushael Lamech)
(wife Lamech Ada)
(son Ada Jabal)
(son Ada Jubal)

(rule (grandson ?g ?s)
      (and (son-r ?f ?s)
           (son-r ?g ?f)))
(rule (son-r ?m ?s)
      (or (son ?m ?s)
          (and (wife ?m ?w)
               (son ?w ?s))))

;; test
(grandson Cain ?person)
;; => (and (son-r ?f ?person)
;;         (son-r Cain ?f))
;; => (and
;;     (or (son ?f ?person)
;;         (and (wife ?f ?w)
;;              (son ?w ?person)))
;;     (or (son Cain ?f) ;; ?f = Enoch
;;         (and (wife Cain ?w2) ;; No result
;;              (son ?w2 ?person))))
;; => (and
;;     (or (son Enoch ?person) ;; ?person Irad
;;         (and (wife Enoch ?w)
;;              (son ?w ?person)))
;;     (son Cain Enoch))
;; => (grandson Cain Irad)


(son-r Lamech ?person)

;; => (or (son Lamech ?person) ;; => No result
;;        (and (wife Lamech ?w) ;; => ?w = Ada
;;             (son ?w ?person))))

;; => (and (wife Lamech Ada) ;; => ?w = Ada
;;         (son Ada ?person)) ;; => ?person = Jabal, Jubal

;; => (son-r Lamech Jabal)
;;    (son-r Lamech Jubal)


(grandson Methushael ?person)

;; ;; => (and (son-r ?f1 ?person)
;; ;;         (son-r Methushael ?f1))

;; ;; => (and (or (son ?f1 ?person)
;; ;;             (and (wife ?f1 ?w1)
;; ;;                  (son ?w1 ?person)))
;; ;;         (or (son Methushael ?f1) ;; ?f1 = Lamech
;; ;;             (and (wife Methushael ?w2) ;; No result
;; ;;                  (son ?w2 ?f1))))

;; ;; => (and (or (son Lamech ?person) ;; No result
;; ;;             (and (wife Lamech ?w1)  ;; ?w1 = Ada
;; ;;                  (son ?w1 ?person)))
;; ;;         (son Methushael Lamech))

;; ;; => (and (and (wife Lamech Ada)
;; ;;              (son Ada ?person)) ;; ?person = Jabal, Jubal
;; ;;         (son Methushael Lamech))

;; ;; => (grandson Methushael Jabal)
;; ;;    (grandson Methushael Jubal)
