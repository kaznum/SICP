;; From text
(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))

;; From DB
(supervisor (Hacker Alyssa P) (Bitdiddle Ben))
(supervisor (Fect Cy D) (Bitdiddle Ben))
(supervisor (Tweakit Lem E) (Bitdiddle Ben))
(supervisor (Reasoner Louis) (Hacker Alyssa P))
(supervisor (Bitdiddle Ben) (Warbucks Oliver))
(supervisor (Scrooge Eben) (Warbucks Oliver))
(supervisor (Cratchet Robert) (Scrooge Eben))
(supervisor (Aull DeWitt) (Warbucks Oliver))

(wheel ?who)


;; ;; '(supervisor ?middle-manager ?person)' extends the empty frames to

;; ({?middle-manager: Hacker, ?person: Bittdiddle}
;;  {?middle-manager: Fect, ?person: Bittdiddle}
;;  {?middle-manager: Tweakit, ?person: Bittdiddle}
;;  {?middle-manager: Reasoner, ?person: Hacker}
;;  {?middle-manager: Bitdiddle, ?person: Warbucks}
;;  {?middle-manager: Scrooge, ?person: Warbucks}
;;  {?middle-manager: Cratchet, ?person: Scrooge}
;;  {?middle-manager: Aull, ?person: Warbucks})


;; ;; '(supervisor ?x ?middle-manager)' filter and extend the frames above to

;; Frame:  {?middle-manager: Hacker, ?person: Bittdiddle}
;; Result: {?middle-manager: Hacker, ?person: Bittdiddle, ?x: Reasoner}

;; Frame:  {?middle-manager: Fect, ?person: Bittdiddle}
;; Result: no frame

;; Frame:  {?middle-manager: Tweakit, ?person: Bittdiddle}
;; Result: no frame

;; Frame:  {?middle-manager: Reasoner, ?person: Hacker}
;; Result: no frame

;; Frame:  {?middle-manager: Bitdiddle, ?person: Warbucks}
;; Result: {?middle-manager: Bitdiddle, ?person: Warbucks, ?x: Hacker}
;;         {?middle-manager: Bitdiddle, ?person: Warbucks, ?x: Fect}
;;         {?middle-manager: Bitdiddle, ?person: Warbucks, ?x: Tweakit}

;; Frame:  {?middle-manager: Scrooge, ?person: Warbucks}
;; Result: {?middle-manager: Scrooge, ?person: Warbucks, ?x: Cratchet}

;; Frame:  {?middle-manager: Cratchet, ?person: Scrooge}
;; Result: no frame

;; Frame:  {?middle-manager: Aull, ?person: Warbucks})
;; Result: no frame


;; now ?who is bound to ?person, so the result of '(wheel ?who)' is
(wheel (Reasoner Bitdiddle Ben)
(wheel (Warbucks Oliver))
(wheel (Warbucks Oliver))
(wheel (Warbucks Oliver))
(wheel (Warbucks Oliver))


