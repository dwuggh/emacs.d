
(use-package haskell-mode
  :defer t
  )

(require 'hs-lint)
;; (use-package flycheck-haskell
;;   :defer t
;;   :init
;;   (add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
;;   )

(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'lsp)
  (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie nil)
  :config
  (lsp-haskell-set-hlint-on)
  (lsp-haskell-set-completion-snippets-on)
  )

(use-package yaml-mode
  :defer t)

(provide 'init-haskell)
