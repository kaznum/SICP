;; When all exchange process is sequentially, the balances of the three accounts are $10, $20, $30 anytime because exchange the balances' difference of accounts each other.

;; When using 'exchange' which is not serialized, the diagram is as follows,

;;          acc_A          acc_B        acc_C
;;           10                          30
;;            |                           |
;;    +-------+--------<--  20  -->-------+-------+
;;    |                                           |
;; diff: -10                                   diff: 10
;;    |                                           |
;; wd: -10(A)                                  wd: 10(C)
;;    |                                           |
;; dp: -10(B)  # serialized                       |
;;    |                                           |
;;    +-------------------> 10                    |
;;    |                                           |
;;    +----> 20                                   |
;;                                                |
;;                                             dp: 10(B) # serialized
;;                                                |
;;                          20 <------------------+
;;                                                |
;;                                       20 <-----+

;; The balances are not 10,20,30, but the sum of them is 60, which is same as the initial state.

;;; When the deposit is not serialized,
;;
;;          acc_A          acc_B        acc_C
;;           10                          30
;;            |                           |
;;    +-------+--------<--  20  -->-------+-------+
;;    |                                           |
;; diff: -10                                   diff: 10
;;    |                                           |
;; wd: -10(A)                                  wd: 10(C)
;;    |                                           |
;; dp: -10(B)                                  dp: 10(B)
;;    |                                           |
;;    +-------------------> 10                    |
;;    |                                           |
;;    |                     30 <------------------+
;;    |                                           |
;;    +-----> 20                                  |
;;                                                |
;;                                       20 <-----+
;;
;; The sum of the balances is 70 which is not same as the initial state.


