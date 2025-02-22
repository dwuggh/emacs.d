
(use-package posframe-plus
  :ensure
  (posframe-plus :host github :repo "zbelial/posframe-plus")
  )

(use-package lspce
  :ensure nil
  :hook
  (rust-mode . lspce-mode)
  
  :load-path "~/Projects/lspce/"
  :config
  (setq lspce-send-changes-idle-time 0.1
        lspce-idle-delay 0.1)
  (setq lspce-show-log-level-in-modeline t
        lspce-eldoc-enable-hover nil
        lspce-eldoc-enable-signature t)
  (setq eldoc-idle-delay 0.1)
  (add-hook 'lspce-mode-hook #'lspce-inlay-hints-mode)
  (define-key lspce-mode-map "K" #'lspce-help-at-point)

  (lspce-set-log-file "/tmp/lspce.log")
  (setq lspce-server-programs
        `(("rust"  "rust-analyzer" "" lspce-ra-initializationOptions)
          ("C" "clangd" "--all-scopes-completion --clang-tidy --enable-config --header-insertion-decorators=0")))
  )



(provide 'init-lspce)

