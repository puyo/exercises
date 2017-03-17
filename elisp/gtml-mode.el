;;; gtml-mode.el --- Simple HTML (and GTML) highlight mode

;; Copyright (C) 1992, 1995, 1996 Free Software Foundation, Inc.

;; Author: Greg McIntyre <greg@puyo.cjb.net>
;; Keywords: wp, hypermedia, comm, languages

;; This file is part of GNU Emacs.

;; GNU Emacs is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Adapted from sgml-mode.el

;;; Code:

(defvar gtml-mode-syntax-table (make-syntax-table))
(modify-syntax-entry ?& "." gtml-mode-syntax-table)
(modify-syntax-entry ?\; "." gtml-mode-syntax-table)
(modify-syntax-entry ?\' "\"" gtml-mode-syntax-table)
(modify-syntax-entry ?\' "\'" gtml-mode-syntax-table)
(modify-syntax-entry ?< "(>" gtml-mode-syntax-table)
(modify-syntax-entry ?> ")<" gtml-mode-syntax-table)

(defvar gtml-font-lock-keywords
  '(
	("\\([^ ]+\\)=" . font-lock-type-face) ; attribute names ..=
	("<\\(/?[-_a-z0-9]+\\)" . font-lock-function-name-face) ; start/end tags < .. >
	("[&%][-.a-z0-9]+;?" . font-lock-variable-name-face) ; entities & .. ;
	("\\(\\#[a-z0-9]+\\)" . font-lock-preprocessor-face) ; pre-processor # ..
	("\\[\\[\\(/?[-_a-z0-9]+?\\)\\]\\]" . font-lock-function-name-face) ; start/end tags [[ .. ]]
	("\\[\\[[-_a-z0-9]+(\\(.+?\\))\\]\\]" . font-lock-string-face) ; parameter lists [[ .. ( .. )]]
	)
  "*Rules for highlighting GTML code.  See also `gtml-tag-face-alist'.")

;; internal
(defvar gtml-font-lock-keywords-1 ())

(defvar gtml-tag-face-alist ()
  "Tag names and face or list of faces to fontify with when invisible.
When `font-lock-maximum-decoration' is 1 this is always used for fontifying.
When more these are fontified together with `gtml-font-lock-keywords'.")

(defvar gtml-display-text ()
  "Tag names as lowercase symbols, and display string when invisible.")

(defun gtml-mode-common (gtml-tag-face-alist gtml-display-text)
  "Common code for setting up `gtml-mode' and derived modes.
GTML-TAG-FACE-ALIST is used for calculating `gtml-font-lock-keywords-1'.
GTML-DISPLAY-TEXT sets up alternate text for when tags are invisible (see
varables of same name)."
  (kill-all-local-variables)
  (setq local-abbrev-table text-mode-abbrev-table)
  (set-syntax-table gtml-mode-syntax-table)
  (make-local-variable 'indent-line-function)
  (make-local-variable 'paragraph-start)
  (make-local-variable 'paragraph-separate)
  (make-local-variable 'comment-start)
  (make-local-variable 'comment-end)
  (make-local-variable 'comment-indent-function)
  (make-local-variable 'comment-start-skip)
  (make-local-variable 'comment-indent-function)
  (make-local-variable 'skeleton-transformation)
  (make-local-variable 'skeleton-further-elements)
  (make-local-variable 'skeleton-end-hook)
  (make-local-variable 'font-lock-defaults)
  (make-local-variable 'gtml-font-lock-keywords-1)
  (and gtml-tag-face-alist
       (not (assq 1 gtml-tag-face-alist))
       (nconc gtml-tag-face-alist
	      `((1 (,(concat "<\\("
			     (mapconcat 'car gtml-tag-face-alist "\\|")
			     "\\)\\([ \t].+\\)?>\\(.+\\)</\\1>")
		    3 (cdr (assoc (match-string 1) ',gtml-tag-face-alist)))))))

  (setq font-lock-defaults '((gtml-font-lock-keywords
						gtml-font-lock-keywords-1)
					   nil
					   t))

  (while gtml-display-text
    (put (car (car gtml-display-text)) 'before-string
	 (cdr (car gtml-display-text)))
    (setq gtml-display-text (cdr gtml-display-text)))
  (run-hooks 'text-mode-hook 'gtml-mode-hook))

;;;###autoload
(defun gtml-mode (&optional function)
  "Major mode for highlighting HTML/GTML documents.

Do \\[describe-variable] gtml- SPC to see available variables."
  (interactive)
  (gtml-mode-common gtml-tag-face-alist gtml-display-text)
  (setq mode-name "GTML"
	major-mode 'gtml-mode))

(provide 'gtml-mode)

;;; gtml-mode.el ends here
