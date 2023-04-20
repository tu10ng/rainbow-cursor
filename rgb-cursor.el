;;; rgb-cursor.el --- make cursor color change periodically
;;; Commentary:

;; The code was written when i first met elisp, and probably the first program i wrote in my life.  It does not have a good code style.  Maybe need some refactor.

;;; Code:


(defgroup rgb-cursor nil
  "rgb light on your cursor"
  :prefix "rgb-cursor-"
  ;; :group
  )

(defcustom rgb-cursor-color-list
  (vector "#FF0000";red
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
		  )
  "list of colors to loop showing for rgb"
  :group 'rgb-cursor)

(defvar rgb-cursor-timer nil
  "a bool variable to check rgb-cursor enable-p, should refactor to minor mode")

(defvar rgb-cursor-color-pointer 1
  "points to the current color in `rgb-cursor-color-list'")

(defvar rgb-cursor-previous-config '((cursor-color . nil)
                                     (blink-cursor-mode . nil))
  "used to restore config when disable")


;; minor mode
(define-minor-mode rgb-cursor-mode
  "Toggle rgb cursor mode.

When rgb-cursor-mode is enabled, cursor will change color with time, according to the colors in `rgb-cursor-color-list'.

This mode is enabled globally."
  :init-value nil
  :global t
  (if rgb-cursor-mode
      (rgb-cursor-enable)
    (rgb-cursor-disable)))


;; utils
(defun rgb-cursor-change-color ()
  "Take a color from `rgb-color-list' by the pointer.
The pointer moves by +1, and restore by taking mod.  "
  (setq rgb-cursor-color-pointer (% (1+ rgb-cursor-color-pointer)
				                    (length rgb-cursor-color-list)))
  (set-cursor-color (elt rgb-cursor-color-list
                         rgb-cursor-color-pointer)))


(defun rgb-cursor-previous-color ()
  "used to restore previous color on disable"
  (face-background 'cursor))

(defun rgb-cursor-store-config ()
  (setcdr (assq 'cursor-color rgb-cursor-previous-config) (rgb-cursor-previous-color))
  (setcdr (assq 'blink-cursor-mode rgb-cursor-previous-config)
          (if blink-cursor-mode
              1
            ;; we need -1 instead of nil
            -1)))

(defun rgb-cursor-restore-config ()
  (set-cursor-color (alist-get 'cursor-color rgb-cursor-previous-config))
  (blink-cursor-mode (alist-get 'blink-cursor-mode rgb-cursor-previous-config)))

(defun rgb-cursor-disable ()
  ""
  (rgb-cursor-restore-config)
  (when rgb-cursor-timer
    (cancel-timer rgb-cursor-timer)
    (setq rgb-cursor-timer nil)))

(defun rgb-cursor-enable ()
  ""
  (rgb-cursor-store-config)
  (blink-cursor-mode -1)
  (when rgb-cursor-timer
    (cancel-timer rgb-cursor-timer)
    (setq rgb-cursor-timer nil))
  (setq rgb-cursor-timer
        (run-with-timer 0 0.05 #'rgb-cursor-change-color)))


;;; Finish up
(provide 'rgb-cursor)

;;; rgb-cursor.el ends here
