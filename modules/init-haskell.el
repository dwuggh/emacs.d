
(use-package haskell-mode
  :defer t
  )


(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'lsp)
  (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie nil)
  )

(provide 'init-haskell)
