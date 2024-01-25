
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize))



(use-package lsp-mode
  :defer t
  :commands lsp-install-server
  :hook
  (
   (python-mode . lsp)
   (c-mode . lsp)
   (c++-mode . lsp)
   )
  :init
  (setq
   lsp-prefer-capf t
   lsp-session-file (concat my-cache-dir ".lsp-session-v1")
   dap-breakpoints-file (concat my-cache-dir ".dap-breakpoints")
   lsp-enable-xref nil
   ;; lsp-use-plists t
   lsp-enable-folding t
   lsp-enable-suggest-server-download nil
   lsp-enable-text-document-color nil
   lsp-lens-enable nil
   )


  ;; (remove-hook 'lsp-completion-mode-hook #'lsp-company-backends-h)
  :config
  (setq lsp-rust-analyzer-server-display-inlay-hints t)
  (add-hook 'lsp-after-open-hook (lambda ()
                                   (when (lsp-find-workspace 'rust-analyzer nil)
                                     (lsp-rust-analyzer-inlay-hints-mode))))
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration)
  (defun lsp-company-backends-h ()
    (interactive)
    (when lsp-completion-mode)
    (set (make-local-variable 'company-backends)
         '((company-capf :with company-yasnippet)
           company-dabbrev-code company-dabbrev))
    )
  (add-hook 'lsp-completion-mode-hook #'lsp-company-backends-h)
  ;; (add-hook 'lsp-mode-hook #'lsp-company-backends-h)

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
   ;; goto
   "gt" #'lsp-find-type-definition
   "gr" #'lsp-find-references
   "gR" #'xref-find-references
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
   "f" '(:ignore t :wk "find & folder")
   "fS" #'lsp-workspace-folders-switch
   "fR" #'lsp-workspace-folders-remove
   "fA" #'lsp-workspace-folders-add
   "fp" #'lsp-ui-peek-find-implementation
   "fs" #'lsp-ui-peek-find-workspace-symbol
   "fd" #'lsp-ui-peek-find-definitions
   "fr" #'lsp-ui-peek-find-references
   ;; text/code
   "x" '(:ignore t :wk "text")
   "xh" #'lsp-document-highlight
   "xl" #'lsp-lens-show
   "xL" #'lsp-lens-hide

   "e" #'(lsp-ui-flycheck-list :wk "list error")
   )
  (defun my-lsp-session ()
    "Get lsp session for current buffer."
    (lsp-find-session-folder (lsp-session) (buffer-file-name))
    )

  (defun my-lsp-init ()
    "My lsp initialization."
    (when (my-lsp-session)
      (lsp))
    )

  (general-def
    :definer 'minor-mode
    :keymaps 'lsp-mode
    "gt" #'lsp-find-type-definition
    "gr" #'lsp-find-references
    "gd" #'lsp-find-definition
    "gR" #'xref-find-references
    "gM" #'lsp-ui-imenu
    )
  )


(use-package lsp-ui
  :after lsp
  :init
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-doc-delay 2000
        lsp-ui-doc-position 'at-point)
  :config
  (general-def
    :keymaps 'lsp-ui-peek-mode-map
    "h" #'lsp-ui-peek--select-prev-file
    "j" #'lsp-ui-peek--select-next
    "k" #'lsp-ui-peek--select-prev
    "l" #'lsp-ui-peek--select-next-file
    )
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

(use-package consult-lsp
  :after lsp-mode)


(setq-mode-local prog-mode
                 company-backends
                 '(company-capf
                   (company-dabbrev-code :with company-yasnippet)
                   company-yasnippet company-dabbrev))


;;; latex
(use-package lsp-latex
  :defer t
  :after lsp
  :init
  (add-hook 'tex-mode-hook #'lsp)
  (add-hook 'latex-mode-hook #'lsp)
  (add-hook 'LaTeX-mode-hook #'lsp)
  )


(setq lsp-clients-clangd-args '(
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--index"
                                "--background-index"
                                "--all-scopes-completion"
                                "--cross-file-rename"
                                ))

(defun lsp-clangd-switch-between-source-headers ()
  "switch between header and source file using clangd."
  (interactive)
  (let* ((resp (lsp-request
                "textDocument/switchSourceHeader"
                (lsp--text-document-identifier)))
         (filename (if (string-prefix-p "file:\/\/" resp)
                       (substring resp 7 nil)
                     resp)))
    (if (not (equal "" filename))
        (switch-to-buffer (find-file-noselect filename))
      (message "didn't find file"))))

(dwuggh/localleader-def
 :keymaps '(c-mode-map c++-mode-map)
 "ss" '(lsp-clangd-switch-between-source-headers :wk "header/source")
 )


;; ;;; python
;; (use-package lsp-pyright
;;   :defer t
;;   :init
;;   (defun lsp-pyright-hook ()
;;     (require 'lsp-pyright)
;;     (lsp)
;;     )
;;   (add-hook 'python-mode-hook #'lsp-pyright-hook)
;;   )



;;; haskell
(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'lsp)
  :config
  (setq haskell-process-auto-import-loaded-modules t
        haskell-process-show-overlays nil
        )
  ;; (lsp-haskell-set-hlint-on)
  ;; (lsp-haskell-set-completion-snippets-on)
  )


(provide 'init-lsp)
