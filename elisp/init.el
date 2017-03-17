
;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

(setq frame-title-format "%b")

(setq load-path (cons (expand-file-name "~/.xemacs") load-path))

(global-set-key [(control d)] 'dictionary-lookup-definition)
(global-set-key [f2] 'font-lock-mode)
(global-set-key [f5] 'greg-fill)
(global-set-key [f6] 'ispell-region)
(global-set-key [f7] 'gdb-step)
(global-set-key [f8] 'gdb-next)
(global-set-key [(control f8)] 'gdb-break)
(global-set-key [(control f9)] 'gdb-cont)
(global-set-key [f9] 'compile)
(global-set-key [(meta left)] 'backward-sentence)
(global-set-key [(meta right)] 'forward-sentence)
(global-set-key [(control up)] 'backward-paragraph)
(global-set-key [(control down)] 'forward-paragraph)
(global-set-key [(control left)] 'backward-word)
(global-set-key [(control right)] 'forward-word)
(global-set-key [(control ?.)] 'increase-left-margin)
(global-set-key [(control ?,)] 'decrease-left-margin)
(global-set-key [(control z)] 'undo)
(global-set-key [(control f4)] 'kill-this-buffer)
(global-set-key [(control *)] 'add-change-log-entry)
(global-set-key [f12] 'insert-diary-entry2)

(defun kill-current-buffer ()
  (interactive)
  (kill-buffer (buffer-name))
)

;; Make global keymap like Windows
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

(autoload 'greg-ml-mode "greg-ml-mode" "Mode for simple HTML/XML file editing." t)
(setq auto-mode-alist (cons '("\\.txt$" . fundamental-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.xml$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.xsl$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.html$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.htm$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rhtml$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.php$" . greg-ml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.php3$" . greg-ml-mode) auto-mode-alist))

(setq auto-mode-alist (cons '("\\.css$" . c-mode) auto-mode-alist))

(setq auto-mode-alist (cons '("\\.pro$" . prolog-mode) auto-mode-alist))

;(cond (running-xemacs
;	   (require 'func-menu)
;	   (define-key global-map "\M-f" 'fume-prompt-function-goto)
;	   ))

(autoload 'pc-select-mode "pc-select")
(pc-select-mode t)

;(add-hook 'font-lock-mode-hook 'turn-on-lazy-lock)
;(setq lazy-lock-stealth-time nil)

(autoload 'greg-fill "greg-fill")
(autoload 'greg-indent "greg-indent")
(autoload 'greg-unindent "greg-indent")

(autoload 'gtml-mode "gtml-mode" "Mode for GTML syntax highlighting" t)
(setq auto-mode-alist (cons '("\\.gtm$" . gtml-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.gtp$" . gtml-mode) auto-mode-alist))

; (autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(autoload 'ruby-mode "ruby-mode")
(setq auto-mode-alist (cons '("\\.rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.rbw$" . ruby-mode) auto-mode-alist))
(setq interpreter-mode-alist (append '(("ruby" . ruby-mode)) interpreter-mode-alist))

(setq auto-mode-alist (cons '("\\.h$" . c++-mode) auto-mode-alist))

(autoload 'run-ruby "inf-ruby"
  "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby"
  "Set local key defs for inf-ruby in ruby-mode")


(add-hook 'ruby-mode-hook
	'(lambda ()
		(load "inf-ruby")
		(load "rubydb3x")
		(define-key ruby-mode-map "\t" '(lambda () (interactive) (setq greg-indent-fallback 'ruby-indent-command) (greg-indent)))
	)
)

(autoload 'pov-mode "pov-mode" "POV-Ray scene file mode" t)
(setq pov-indent-level '4)
(setq pov-autoindent-endblocks t)
(setq pov-indent-under-declare '4)
(setq pov-fontify-insanely t)
(setq auto-mode-alist
	  (append
	   '(("\\.pov$" . pov-mode)
		 ("\\.inc$" . pov-mode)
		 )auto-mode-alist))
(add-hook 'pov-mode-hook
		  '(lambda ()
			 (setq comment-column 36)
			 (abbrev-mode t)))

(global-set-key "\t" 'greg-indent)
(global-set-key [(iso-left-tab)] 'greg-unindent)

(add-hook 'c-mode-hook '(lambda ()
	(define-key c-mode-map "\t" '(lambda () (interactive) (setq greg-indent-fallback 'c-indent-command) (greg-indent)))
  )
)
(add-hook 'c++-mode-hook '(lambda ()
	(define-key c++-mode-map "\t" '(lambda () (interactive) (setq greg-indent-fallback 'c++-indent-command) (greg-indent)))
  )
)
(add-hook 'greg-ml-mode-hook '(lambda ()
	(define-key greg-ml-mode-map "\t" '(lambda () (interactive) (setq greg-indent-fallback nil) (greg-indent)))
  )
)
(add-hook 'makefile-mode-hook '(lambda ()
	(define-key greg-ml-mode-map "\t" '(lambda () (interactive) (setq greg-indent-fallback nil) (greg-indent)))
  )
)
