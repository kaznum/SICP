(meeting accounting (Monday 9am))
(meeting administration (Monday 10am)
(meeting computer (Wednesday 3pm)
(meeting administration (Friday 1pm)

(meeting whole-company (Wednesday 4pm))

;; a.
(meeting ?division (Friday ?hour))

;; b.
(rule (meeting-time ?person ?day-and-time)
      (and (job ?person (?division . ?section))
           (or (meeting ?division ?day-and-time)
               (meeting whole-company ?day-and-time))))

;; c.
(meeting-time (Hacker Alyssa P) (Wednesday ?hour))
