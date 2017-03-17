;;; greg-ml-mode.el --- Multi-purpose text fill.

(defun greg-fill-current-indentation ()
  (save-excursion
    (beginning-of-line)
    (back-to-indentation)
    (current-column)
  )
)
	
(defun greg-region-active ()
  (or (and zmacs-regions (zmacs-region-buffer)) (region-active-p))
)

(defun greg-fill ()
  (interactive)
  (save-excursion
    (let ((fill-indentation (greg-fill-current-indentation)))
      (if (greg-region-active)
        (fill-paragraph-or-region nil)
        (if (> fill-indentation 0)
          (greg-fill-indented-paragraph fill-indentation)
          (fill-paragraph-or-region nil)
        )
      )
    )
  )
  (zmacs-deactivate-region)
)

(defun greg-fill-indented-paragraph (fill-indentation)
  (greg-fill-set-point fill-indentation -1)
  (forward-line)
  (beginning-of-line)
  (push-mark (point) t)
  (greg-fill-set-point fill-indentation +1)
  (beginning-of-line)
  (let ((beg (point)))
    (exchange-point-and-mark)
    (fill-region-as-paragraph beg (point))
  )
)


(defun greg-fill-set-point (fill-indentation offset)
  (while (equal fill-indentation (greg-fill-current-indentation))
    (forward-line offset)
  )
)
