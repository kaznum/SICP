;; If there are resource A, B, C .... and they have some relationship chainedly
;; A -> B -> C -> D -> A
;; and if an operation to a resource needs to finish before the upper source's operation goes on, this might get deadlock.
