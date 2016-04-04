(and (job ?x (computer programmer))
     (supervisor ?x ?y))

(and (supervisor ?x ?y)
     (job ?x (computer programmer)))
;; If supervisors is less than programmer,
;; the first is better than the second because
;; the number of intermediate frames is less.

;; The aim of logical programming is to provide the programmers
;; the technique of decomposing 'what' is to be computed and 'how' that should be computed.

;; 'Rule' holds the 'way' to compute the problem procedurally in body, at the same time,
;; this can be regarded as the 'statement(what)' of methematical logic (inference).

;;;; Inifinite loops


;; to be continued


