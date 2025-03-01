
;; (use-package exec-path-from-shell
;;   :config
;;   (exec-path-from-shell-initialize))



(use-package lsp-mode
  :commands lsp-install-server
  :hook
  (
   (python-mode . lsp)
   (python-ts-mode . lsp)
   (c-mode . lsp)
   (c++-mode . lsp)
   (c-or-c++-mode . lsp)
   (c-ts-mode . lsp)
   (c++-ts-mode . lsp)
   (c-or-c++-ts-mode . lsp)
   (go-ts-mode . lsp)
   (wgsl-ts-mode . lsp)
   (typescript-mode . lsp)
   )
  :init
  (setq
   ;; lsp-prefer-capf t
   lsp-session-file (concat my-cache-dir ".lsp-session-v1")
   dap-breakpoints-file (concat my-cache-dir ".dap-breakpoints")
   lsp-enable-xref nil
   ;; lsp-use-plists t
   lsp-enable-folding nil
   lsp-enable-suggest-server-download nil
   lsp-enable-text-document-color nil
   lsp-lens-enable t
   lsp-inlay-hint-enable t
   lsp-ui-imenu-kind-position 'top
   lsp-headerline-breadcrumb-enable nil
   lsp-diagnostics-provider :flymake
   )


  :config
  ;; (require 'lsp-wgsl)
  ;; (setq lsp-rust-analyzer-server-display-inlay-hints t)
  ;; (add-hook 'lsp-after-open-hook (lambda ()
  ;;                                  (when (lsp-find-workspace 'rust-analyzer nil)
  ;;                                    (lsp-rust-analyzer-inlay-hints-mode))))
  ;; (add-to-list 'lsp-language-id-configuration '(latex-ts-mode . "latex"))
  ;; (add-to-list 'lsp-language-id-configuration '(wgsl-ts-mode . "wgsl"))
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration)
  (setq lsp-completion-provider :none)
  (add-hook 'lsp-mode-hook #'lsp-completion-mode)
  (add-hook 'lsp-mode-hook #'lsp-inlay-hints-mode)

  ;;; lsp-booster config
  (defun lsp-booster--advice-json-parse (old-fn &rest args)
    "Try to parse bytecode instead of json."
    (or
     (when (equal (following-char) ?#)
       (let ((bytecode (read (current-buffer))))
         (when (byte-code-function-p bytecode)
           (funcall bytecode))))
     (apply old-fn args)))
  (advice-add (if (progn (require 'json)
                         (fboundp 'json-parse-buffer))
                  'json-parse-buffer
                'json-read)
              :around
              #'lsp-booster--advice-json-parse)

  (defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
    "Prepend emacs-lsp-booster command to lsp CMD."
    (let ((orig-result (funcall old-fn cmd test?)))
      (if (and (not test?)                             ;; for check lsp-server-present?
               (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
               lsp-use-plists
               (not (functionp 'json-rpc-connection))  ;; native json-rpc
               (executable-find "emacs-lsp-booster"))
          (progn
            (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
              (setcar orig-result command-from-exec-path))
            (message "Using emacs-lsp-booster for %s!" orig-result)
            (cons "emacs-lsp-booster" orig-result))
        orig-result)))
  (advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

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

  (general-define-key
   ;; :definer 'minor-mode
   :predicate 'lsp-mode
   ;; :keymaps 'local
   "gt" #'lsp-find-type-definition
   "gr" #'lsp-find-references
   "gd" #'lsp-find-definition
   "gR" #'xref-find-references
   "gM" #'lsp-ui-imenu
   )
  (general-def 'normal lsp-mode
    :definer 'minor-mode
    ",l" lsp-command-map)
  ;; (evil-define-minor-mode-key
  ;;   'normal 'lsp-mode "gd" #'lsp-find-definition
  ;;   )
  )


(use-package lsp-ui
  :after lsp
  :init
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-doc-delay 2000
        lsp-ui-doc-position 'at-point)
  :config
  (general-define-key
   :predicate 'lsp-ui-peek-mode
   "h" #'lsp-ui-peek--select-prev-file
   "j" #'lsp-ui-peek--select-next
   "k" #'lsp-ui-peek--select-prev
   "l" #'lsp-ui-peek--select-next-file
   )
  (define-key lsp-ui-peek-mode-map (kbd "C-j") #'lsp-ui-peek--select-next)
  (define-key lsp-ui-peek-mode-map (kbd "C-k") #'lsp-ui-peek--select-prev)
  (define-key lsp-ui-peek-mode-map (kbd "j") #'lsp-ui-peek--select-next)
  (define-key lsp-ui-peek-mode-map (kbd "k") #'lsp-ui-peek--select-prev)
  (define-key lsp-ui-peek-mode-map (kbd "h") #'lsp-ui-peek--select-prev-file)
  (define-key lsp-ui-peek-mode-map (kbd "l") #'lsp-ui-peek--select-next-file)
  (defun lsp-ui-doc-toggle ()
    "toggle lsp ui doc."
    (interactive)
    (if (lsp-ui-doc--frame-visible-p)
        (lsp-ui-doc-hide)
      (lsp-ui-doc-show)
      ))
  (general-define-key
   :predicate 'lsp-ui-mode
   :states '(normal visual)
   "K" 'lsp-ui-doc-toggle
   )
  )

(use-package consult-lsp
  :after lsp-mode)


(use-package lsp-treemacs
  :after lsp
  :config
  (lsp-treemacs-sync-mode 1)
  )

;;; latex
(use-package lsp-latex
  :defer t
  :init
  (add-hook 'tex-mode-hook #'lsp)
  (add-hook 'latex-mode-hook #'lsp)
  (add-hook 'LaTeX-mode-hook #'lsp)
  :config
  (lsp-register-client
   (make-lsp-client :new-connection
                    (lsp-stdio-connection
                     #'lsp-latex-new-connection)
                    :major-modes '(tex-mode
                                   yatex-mode
                                   latex-mode
                                   latex-ts-mode
                                   bibtex-mode)
                    :server-id 'texlab2
                    :priority 2
                    :initialized-fn
                    (lambda (workspace)
                      (with-lsp-workspace workspace
                                          (lsp--set-configuration
                                           (lsp-configuration-section "latex"))
                                          (lsp--set-configuration
                                           (lsp-configuration-section "bibtex"))))
                    :notification-handlers
                    (lsp-ht
                     ("window/progress"
                      'lsp-latex-window-progress))
                    :after-open-fn
                    (lambda ()
                      (setq-local lsp-completion-sort-initial-results lsp-latex-completion-sort-in-emacs))))

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

(use-package rustic
    :after (rust-mode)
    :init
    (setq rustic-lsp-setup-p t)
    :config
    (defvaralias 'rustic-indent-offset 'rust-ts-mode-indent-offset)
    (setq
     lsp-rust-analyzer-macro-expansion-method 'lsp-rust-analyzer-macro-expansion-default))

(provide 'init-lsp)
