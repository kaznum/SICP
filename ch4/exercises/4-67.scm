;; The history should have 'pattern', 'frame' and 'counter'
;; Before applying a frame to a pattern, it searches the history then its counter is not more than the boundary value, then adds 1 to the counter and apply the frame.
;; On the other hand, the counter is more than the boundary value then abandon the query.
