;; From text
(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))

;; Answer
(rule (reverse () ()))
(rule (reverse (?a) (?a)))
(rule (reverse (?head . ?tail) ?reversed)
      (and (reverse ?tail ?reversed-tail)
           (append-to-form ?reversed-tail (?head) ?reversed)))

;; TEST
(reverse (1 2 3) ?x)
;; frame1: ?head=1 ?tail=(2 3)
;; (rule (reverse (?1 . (2 3)) ?reversed)
;;   (and (reverse (2 3) ?reversed-tail)
;;        (append-to-form ?reversed-tail (1) ?reversed)))
;; =>
;; frame1-1: ?head=2 ?tail=(3)
;; (rule (reverse (?2 . (3)) ?reversed)
;;   (and (reverse (3) ?reversed-tail)
;;        (append-to-form ?reversed-tail (2) ?reversed)))
;; =>
;; frame1-1-1: ?head=3 ?tail=()
;; (rule (reverse (3 . ()) ?reversed)
;;   (and (reverse () ?reversed-tail)
;;        (append-to-form ?reversed-tail (3) ?reversed)))
;; frame1-1-1: ?head=3 ?tail=() ?reversed-tail=() ?reversed=(3)
;; =>
;; frame1-1: ?head=2 ?tail=(3), ?reversed-tail=(3) ?reversed=(3 2)
;; =>
;; frame1: ?head=1 ?tail=(2 3), ?reversed-tail=(3 2) ?reversed=(3 2 1)


(reverse ?x (1 2 3))

;; frame1: ?reversed=(1 2 3)
;; (rule (reverse (?head . ?tail) (1 2 3))
;;   (and (reverse ?tail ?reversed-tail) ;;*
;;        (append-to-form ?reversed-tail (?head) (1 2 3))))
;; frame1: ?reversed=(1 2 3), ?reversed-tail=(1 2), ?head=3
;; =>
;; frame1-1: ?reversed=(1 2)
;; (rule (reverse (?head . ?tail) (1 2))
;;   (and (reverse ?tail ?reversed-tail) ;;*
;;        (append-to-form ?reversed-tail (?head) (1 2))))
;; frame1-1: ?reversed=(1 2), ?reversed-tail=(1), ?head=2
;; =>
;; frame1-1-1: ?reversed=(1)
;; (rule (reverse (?head . ?tail) (1))
;;   ...
;; frame1-1-1: ?reversed=(3), ?reversed-tail=(), ?head=1, ?tail=() ;; resolved by (rule (reverse (?a) (?a)))
;; =>
;; frame1-1: ?reversed=(1 2), ?reversed-tail=(1), ?head=2, ?tail=(1)
;; =>
;; frame1: ?reversed=(1 2 3), ?reversed-tail=(2 3), ?head=3, ?tail=(2 1)
;; (?head . ?tail) = (3 . (2 1) = (3 2 1)

