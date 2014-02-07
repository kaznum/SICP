;;; Without calling when proc is added, the first set-signal! calls after-delay (which stores an action to agenda) for the first time.
;;; This means the items in agenda are not called for the initial set-signal! and makes nothing changed


