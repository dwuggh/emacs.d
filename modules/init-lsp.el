

(use-package lsp-mode
  :defer t
  :init
  (setq lsp-keymap-prefix "SPC l"
	lsp-prefer-capf t
	)
  :config
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration)
  (dwuggh/localleader-def
   :keymaps 'lsp-mode-map
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
    ;; N.B. implementation and references covered by xref bindings / lsp provider...
    "gt" #'lsp-find-type-definition
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
  :defer t)





(provide 'init-lsp)
