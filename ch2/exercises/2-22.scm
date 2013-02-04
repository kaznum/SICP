;; In the first case, the first element is picked up and transformed and put on the top 'answer' list,
;; then goes to the next iteration. The next transformed element is put on the top of the answer which is in front of the first element.
;; So the list is reversed.


;; In the second case, there is '(cons answer (square ...))' where answer is list. This means the answer list becomes one of the element in the result of (square ...).
;; ex. (list (list ... (list ....), 100)

