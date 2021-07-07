
(use-package haskell-mode
  :defer t
  )

(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'my-lsp-init)
  (add-hook 'haskell-literate-mode-hook #'my-lsp-init)
  ;; (setq lsp-haskell-process-path-hie "haskell-language-server-8.10.2")
  ;; (setq lsp-haskell-process-args-hie nil)
  ;; (setq lsp-haskell-server-path "/home/dwuggh/.ghcup/bin/haskell-language-server-wrapper")
  ;; (setq lsp-haskell-server-path "/home/dwuggh/.local/bin/ghcide")
  :config
  ;; (lsp-haskell-set-hlint-on)
  ;; (lsp-haskell-set-completion-snippets-on)
  )

(use-package yaml-mode
  :defer t)

(provide 'init-haskell)
