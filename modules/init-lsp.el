
(use-package exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(use-package lsp-mode
  :defer t
  :init
  (setq
   lsp-prefer-capf t
   lsp-session-file (concat my-cache-dir ".lsp-session-v1")
   dap-breakpoints-file (concat my-cache-dir ".dap-breakpoints")
   ;; lsp-use-plists t
   )
  (defun lsp-company-backends-h ()
    (interactive)
    (when lsp-completion-mode)
    (set (make-local-variable 'company-backends)
	 '((company-capf :with company-yasnippet)
	  company-dabbrev-code company-dabbrev))
    )
  (add-hook 'lsp-completion-mode-hook #'lsp-company-backends-h)
  (add-hook 'lsp-mode-hook #'lsp-company-backends-h)
  ;; (remove-hook 'lsp-completion-mode-hook #'lsp-company-backends-h)
  :config
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration)

  (dwuggh/localleader-def
   :definer 'minor-mode
   :keymaps 'lsp-mode
    "=" '(:ignore t :wk "format")
    "=b" #'lsp-format-buffer
    "=r" #'lsp-format-region
    "=o" #'lsp-organize-imports
    ;; code actions
    "a" '(:ignore t :wk "action")
    "aa" #'lsp-execute-code-action
    ;; "af" #'spacemacs//lsp-action-placeholder
    ;; "ar" #'spacemacs//lsp-action-placeholder
    ;; "as" #'spacemacs//lsp-action-placeholder
    ;; goto
    "gt" #'lsp-find-type-definition
    "gr" #'lsp-find-references
    "gR" #'xref-find-references
    ;; "gk" #'spacemacs/lsp-avy-goto-word
    ;; "gK" #'spacemacs/lsp-avy-goto-symbol
    "gM" #'lsp-ui-imenu
    ;; help
    "hh" #'lsp-describe-thing-at-point
    ;; jump
    ;; backend
    "b" '(:ignore t :wk "backend")
    "bd" #'lsp-describe-session
    "br" #'lsp-workspace-restart
    "bs" #'lsp-workspace-shutdown
    ;; refactor
    "r" '(:ignore t :wk "refactor")
    "rr" #'lsp-rename
    ;; toggles
    "T" '(:ignore t :wk "toggles")
    "Td" #'lsp-ui-doc-mode
    "Ts" #'lsp-ui-sideline-mode
    ;; "TF" #'spacemacs/lsp-ui-doc-func
    ;; "TS" #'spacemacs/lsp-ui-sideline-symb
    ;; "TI" #'spacemacs/lsp-ui-sideline-ignore-duplicate
    "Tl" #'lsp-lens-mode
    ;; folders
    "f" '(:ignore t :wk "folder")
    "fs" #'lsp-workspace-folders-switch
    "fr" #'lsp-workspace-folders-remove
    "fa" #'lsp-workspace-folders-add
    ;; text/code
    "x" '(:ignore t :wk "text")
    "xh" #'lsp-document-highlight
    "xl" #'lsp-lens-show
    "xL" #'lsp-lens-hide
   )
  )


(use-package lsp-ui
  :defer t
  :config
  (general-def
    :keymaps 'lsp-ui-peek-mode-map
    "h" #'lsp-ui-peek--select-prev-file
    "j" #'lsp-ui-peek--select-next
    "k" #'lsp-ui-peek--select-prev
    "l" #'lsp-ui-peek--select-next-file
    )
  (setq lsp-ui-doc-delay 2000
	lsp-ui-doc-position 'at-point)
  (defun lsp-ui-doc-toggle ()
    "toggle lsp ui doc."
    (interactive)
    (if (lsp-ui-doc--frame-visible-p)
	(lsp-ui-doc-hide)
      (lsp-ui-doc-show)
      ))
  (general-def
   :definer 'minor-mode
   :keymaps 'lsp-mode
   "K" 'lsp-ui-doc-toggle
   )
  )

;; popwin
(push '("*lsp-help*"
	:dedicated t :position bottom
	:stick t :noselect nil :height 0.4)
      popwin:special-display-config)

(push '("*xref*"
	:dedicated t :position bottom
	:stick t :noselect nil :height 0.4)
      popwin:special-display-config)


(setq-mode-local prog-mode
		 company-backends
	      '(company-capf
		(company-dabbrev-code :with company-yasnippet)
		company-yasnippet company-dabbrev))


(provide 'init-lsp)
