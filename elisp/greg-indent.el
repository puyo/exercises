;;; greg-indent.el --- Intelligent tab indentation/unindentation.

(defvar greg-indent-fallback 'insert-tab
  "*Method called to indent if region is not active.")

(defun greg-do-indent (num)
  (if (> (mark) (point))
	(indent-rigidly (point) (mark) (* num tab-width))
	(indent-rigidly (mark) (point) (* num tab-width))
  )
  (zmacs-activate-region)
)
			
(defun greg-indent ()
  (interactive)
  (if (greg-region-active)
    (greg-do-indent 1)
    (if greg-indent-fallback
      (run-hooks 'greg-indent-fallback)
      (insert-tab)
    )
  )
)

(defun greg-unindent ()
  (interactive)
  (if (greg-region-active)
    (greg-do-indent -1)
    (if greg-indent-fallback
      (run-hooks 'greg-indent-fallback)
      (insert-tab)
    )
  )
)
	
(defun greg-region-active ()
  (or (and zmacs-regions (zmacs-region-buffer)) (region-active-p))
)
