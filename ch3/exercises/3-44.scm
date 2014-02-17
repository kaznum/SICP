;; Louis is wrong.
;; Exchange has to calculate the difference of the balances between two accounts , so 'exchange' itself needs to be serialized to prevent the balances are not changed during the exchange, but 'transfer' does not need to calc the diff of them because the amount to transfer is specified as an argument.
