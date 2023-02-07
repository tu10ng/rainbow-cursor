;;; rainbow-cursor.el --- make cursor color change periodically
;;; Commentary:

;; The code was written when i first met elisp, and probably it is the first program i wrote in my life.  It does not have a good code style.  Maybe need some refactor.

;;; Code:


(blink-cursor-mode -1)
(set-cursor-color "gold")

(defvar rainbow-cursor-timer nil)
(setq rainbow-cursor-color-list (vector"#FF0000";red
		                               "#FF5000"
		                               "#FF9F00";orange
		                               "#FFFF00";yellow
		                               "#BFFF00"
		                               "#00FF00";green
		                               "#00FFFF";
		                               "#0088FF"
		                               "#0000FF";blue
		                               "#5F00FF"
		                               "#8B00FF";purple
		                               "#CF00FF"
		                               "#FF0088"
		                               ))
(setq rainbow-cursor-color-pointer 1)
(defun rainbow-cursor-change-color ()
  "Take a color from `rainbow-color-list' by the pointer.
The pointer moves by +1, and restore by taking mod.  "
  (setq rainbow-cursor-color-pointer (% (1+ rainbow-cursor-color-pointer)
				                        (length rainbow-cursor-color-list)))
  (set-cursor-color (elt rainbow-cursor-color-list
                         rainbow-cursor-color-pointer)))

(defun rainbow-cursor-disable ()
  ""
  (interactive)
  (when rainbow-cursor-timer
    (cancel-timer rainbow-cursor-timer)
    (setq rainbow-cursor-timer nil)))

(defun rainbow-cursor-enable ()
  ""
  (interactive)
  (rainbow-cursor-disable)
  (setq rainbow-cursor-timer
        (run-with-timer 0 0.05 #'rainbow-cursor-change-color)))

(rainbow-cursor-enable)


;;; Finish up
(provide 'rainbow-cursor)

;;; rainbow-cursor.el ends here
