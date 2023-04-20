;;; rgb-cursor.el --- make cursor color change periodically

;; Author: tu10ng <2059734099@qq.com>
;; URL: https://github.com/tu10ng/rgb-cursor
;; Keywords: convenience

;; This file is NOT part of GNU Emacs

;;; Commentary:

;; The code was written when i first met elisp, and probably the first program i wrote in my life.  It does not have a good code style.  Maybe need some refactor.

;; See the README for more info: https://github.com/tu10ng/rgb-cursor

;;; Code:


;; custom

(defgroup rgb-cursor nil
  "rgb light on your cursor"
  :group 'convenience
  :prefix "rgb-cursor-"
  )

(defcustom rgb-cursor-color-list
  (vector "#FF0000";red
		  "#FF5000"
          "#FF9F00";orange
		  "#FFFF00";yellow
		  "#BFFF00"
		  "#00FF00";green
		  "#00FFFF"
		  "#0088FF"
		  "#0000FF";blue
		  "#5F00FF"
		  "#8B00FF";purple
		  "#CF00FF"
		  "#FF0088"
		  )
  "list of colors to loop showing for rgb"
  :group 'rgb-cursor)


;; inner variables

(defvar rgb-cursor--timer nil
  "a bool variable to check rgb-cursor enable-p, should refactor to minor mode")

(defvar rgb-cursor--color-counter 0
  "a counter points to the current color in `rgb-cursor-color-list'")

(defvar rgb-cursor--previous-config '((cursor-color . nil)
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
      (rgb-cursor--enable)
    (rgb-cursor--disable)))


;; utils
(defun rgb-cursor-current-color ()
  "can be used with other packages.
another usage is to restore previous color on disable"
  (face-background 'cursor))


;; inner functions
(defun rgb-cursor--change-color ()
  "Take a color from `rgb-color-list' by `rgb-cursor--color-counter'
increase `rgb-cursor--color-counter', and loop back by taking mod over its length."
  (setq rgb-cursor--color-counter (% (1+ rgb-cursor--color-counter)
				                     (length rgb-cursor-color-list)))
  (let ((color (elt rgb-cursor-color-list
                    rgb-cursor--color-counter)))
    (set-cursor-color color)))

(defun rgb-cursor--store-config ()
  "store some config in `rgb-cursor--previous-config'"
  (setcdr (assq 'cursor-color rgb-cursor--previous-config)
          (rgb-cursor-current-color))
  (setcdr (assq 'blink-cursor-mode rgb-cursor--previous-config)
          (if blink-cursor-mode
              1
            ;; we need -1 instead of nil
            -1)))

(defun rgb-cursor--restore-config ()
  (set-cursor-color (alist-get 'cursor-color rgb-cursor--previous-config))
  (blink-cursor-mode (alist-get 'blink-cursor-mode rgb-cursor--previous-config)))

(defun rgb-cursor--disable ()
  "remove the timer stored in `rgb-cursor--timer'"
  (rgb-cursor--restore-config)
  (when rgb-cursor--timer
    (cancel-timer rgb-cursor--timer)
    (setq rgb-cursor--timer nil)))

(defun rgb-cursor--enable ()
  "change blink-cursor-mode, and add the timer"
  (rgb-cursor--store-config)
  (blink-cursor-mode -1)
  ;; need cancel previous timer or multiple timer will be established
  (when rgb-cursor--timer
    (cancel-timer rgb-cursor--timer)
    (setq rgb-cursor--timer nil))
  (setq rgb-cursor--timer
        (run-with-timer 0 0.05 #'rgb-cursor--change-color)))


;;; Finish up
(provide 'rgb-cursor)

;;; rgb-cursor.el ends here
