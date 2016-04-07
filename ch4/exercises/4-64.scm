;; The original rule
(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (supervisor ?staff-person ?middle-manager)
               (outranked-by ?middle-manager ?boss))))

;; Exercise rule
(rule (outranked-by ?staff-person ?boss)
      (or (supervisor ?staff-person ?boss)
          (and (outranked-by ?middle-manager ?boss)
               (supervisor ?staff-person
                           ?middle-manager))))

;; The flow by Exercise rule

(outranked-by (Ben Bitdiddle) ?who)

(or
 (supervisor (Ben Bitdiddle) ?who) [A]
 (and
  (outranked-by ?x ?who) [B]
  (supervisor (Ben Bitdiddle) ?x) [C]
  ))



;; frame:((?staff: Ben)) ----- (supervisor ?staff ?boss)[A]-----------------------------------[merge]
;;                        |                                                                       |
;;                        |                                                                       |
;;                        |                                                                       |
;;                        `-- (outranked-by ?middle ?boss)[B]---- (supervisor ?staff ?middle)[C]--'


;; At [A], the frames are extended.
;; ((?staff: Ben, ?boss: Warbucks))

;; At [B] both of ?middle and ?boss are still unbound, then 'outranked-by' rule body is applied,
;; [B][A] extends the frames generate the stream which contains all 'supervisor' patterns of DB
;;  (?middle: ..., ?boss: ...  , outer: (?staff: Ben))
;;  (?middle: ..., ?boss: ...  , outer: (?staff: Ben))
;;  (?middle: ..., ?boss: ...  , outer: (?staff: Ben))
;;  (?middle: ..., ?boss: ...  , outer: (?staff: Ben))

;; [C] filters the frames passed from [B][A]
;; At the same time, [B][B] is processed with unbound variables(?middle and ?boss) then generates same frames [B][A]

;; The frames are passed to the next filter continuously because it is in stream, but [B][A] generates the same frames forever, then infinite loop occurs.

;; On the other hand, the original rule filters by (supervisor ?staff-person ?middle-manager) at first because ?staff-person is bound, so the process finishes.
