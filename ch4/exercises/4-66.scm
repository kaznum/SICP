;; The stream of frames to be fed to the accumuration-function contains the duplicated frames.
;; Ben has to ignore the frames which have been already fed to the accumuration-function in advance.

;; To do this, the frame that is fed should be cached and the followers should be checked whether
;; there is in the cache, then only when it is not in the cache, pass the frame to accumuration-function.
