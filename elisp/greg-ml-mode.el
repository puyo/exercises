;;; greg-ml-mode.el --- Simple HTML/XML highlight and indentation mode

(defvar greg-ml-mode-syntax-table (make-syntax-table))
(modify-syntax-entry ?& "." greg-ml-mode-syntax-table)
(modify-syntax-entry ?\; "." greg-ml-mode-syntax-table)
(modify-syntax-entry ?\' "\"" greg-ml-mode-syntax-table)
(modify-syntax-entry ?\' "\'" greg-ml-mode-syntax-table)
(modify-syntax-entry ?< "(>" greg-ml-mode-syntax-table)
(modify-syntax-entry ?> ")<" greg-ml-mode-syntax-table)

(defvar greg-ml-font-lock-keywords
  '(
	("\\([-_a-z0-9:]+\\)=" 1 font-lock-type-face) ; attribute names ..=
	("<\\(\\?[-_a-z0-9:]*\\w\\)" 1 font-lock-preprocessor-face) ; processing tags <? .. ?>
	("\\(\\?\\)>" 1 font-lock-preprocessor-face) ; processing tags <? .. ?>
	("<\\(/?[-_a-z0-9:]+\\)" 1 font-lock-function-name-face) ; start/end tags < .. >
	("[&%][-.a-z0-9]+;?" 0 font-lock-variable-name-face) ; entities & .. ;
	("<!--.*?-->" 0 font-lock-comment-face) ; comments <!-- .. -->
	("<!\\([A-Z]+\\)" 1 font-lock-preprocessor-face) ; DOM defs <! .. >
	)
  "*Rules for highlighting HTML/XML code.  See also `greg-ml-tag-face-alist'.")

;; internal
(defvar greg-ml-font-lock-keywords-1 ())

(defvar greg-ml-tag-face-alist ()
  "Tag names and face or list of faces to fontify with when invisible.
When `font-lock-maximum-decoration' is 1 this is always used for fontifying.
When more these are fontified together with `greg-ml-font-lock-keywords'.")

(defvar greg-ml-display-text ()
  "Tag names as lowercase symbols, and display string when invisible.")

(defvar greg-ml-mode-map nil "Keymap used in Greg-ML mode.")

(if greg-ml-mode-map
    nil
  (setq greg-ml-mode-map (make-sparse-keymap))
  (define-key greg-ml-mode-map "\C-m" 'greg-ml-newline-and-indent)
  (define-key greg-ml-mode-map "\C-j" 'newline)
  (define-key greg-ml-mode-map "\t" 'greg-ml-indent))

(defun greg-ml-indent (&optional function)
  (interactive)
  (insert-tab)
)

(defun greg-ml-current-indentation ()
  (save-excursion
    (beginning-of-line)
    (back-to-indentation)
    (current-column)
  )
)

(defun greg-ml-newline-and-indent (&optional function)
  (interactive)
  (defvar last-indent ())
  (setq last-indent(greg-ml-current-indentation))
  (newline)
  (if (> last-indent 0) (indent-relative) ())
)

(defun greg-ml-mode-common (greg-ml-tag-face-alist greg-ml-display-text)
  "Common code for setting up `greg-ml-mode' and derived modes.
GREG-ML-TAG-FACE-ALIST is used for calculating `greg-ml-font-lock-keywords-1'.
GREG-ML-DISPLAY-TEXT sets up alternate text for when tags are invisible (see
varables of same name)."
  (kill-all-local-variables)
  (use-local-map greg-ml-mode-map)
  (setq local-abbrev-table text-mode-abbrev-table)
  (set-syntax-table greg-ml-mode-syntax-table)
  (make-local-variable 'greg-ml-font-lock-keywords-1)
  (and greg-ml-tag-face-alist
       (not (assq 1 greg-ml-tag-face-alist))
       (nconc greg-ml-tag-face-alist
	      `((1 (,(concat "<\\("
			     (mapconcat 'car greg-ml-tag-face-alist "\\|")
			     "\\)\\([ \t].+\\)?>\\(.+\\)</\\1>")
		    3 (cdr (assoc (match-string 1) ',greg-ml-tag-face-alist)))))))

  (setq font-lock-defaults '((greg-ml-font-lock-keywords
						greg-ml-font-lock-keywords-1)
					   nil
					   t))

  (while greg-ml-display-text
    (put (car (car greg-ml-display-text)) 'before-string
	 (cdr (car greg-ml-display-text)))
    (setq greg-ml-display-text (cdr greg-ml-display-text)))
  (run-hooks 'text-mode-hook 'greg-ml-mode-hook))

;;;###autoload
(defun greg-ml-mode (&optional function)
  "Major mode for highlighting HTML/XML documents.

Do \\[describe-variable] greg-ml- SPC to see available variables."
  (interactive)
  (greg-ml-mode-common greg-ml-tag-face-alist greg-ml-display-text)
  (setq mode-name "Greg-ML"
	major-mode 'greg-ml-mode))

(provide 'greg-ml-mode)

;;; greg-ml-mode.el ends here

