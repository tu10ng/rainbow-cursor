;;; rgb-cursor.el --- make cursor color change periodically
;;; Commentary:

;; The code was written when i first met elisp, and probably the first program i wrote in my life.  It does not have a good code style.  Maybe need some refactor.

;;; Code:


(blink-cursor-mode -1)
(set-cursor-color "gold")

(defvar rgb-cursor-timer nil)
(setq rgb-cursor-color-list (vector"#FF0000";red
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
(setq rgb-cursor-color-pointer 1)
(defun rgb-cursor-change-color ()
  "Take a color from `rgb-color-list' by the pointer.
The pointer moves by +1, and restore by taking mod.  "
  (setq rgb-cursor-color-pointer (% (1+ rgb-cursor-color-pointer)
				                        (length rgb-cursor-color-list)))
  (set-cursor-color (elt rgb-cursor-color-list
                         rgb-cursor-color-pointer)))

(defun rgb-cursor-disable ()
  ""
  (interactive)
  (when rgb-cursor-timer
    (cancel-timer rgb-cursor-timer)
    (setq rgb-cursor-timer nil)))

(defun rgb-cursor-enable ()
  ""
  (interactive)
  (rgb-cursor-disable)
  (setq rgb-cursor-timer
        (run-with-timer 0 0.05 #'rgb-cursor-change-color)))

(rgb-cursor-enable)


;;; Finish up
(provide 'rgb-cursor)

;;; rgb-cursor.el ends here
