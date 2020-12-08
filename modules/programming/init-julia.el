
(use-package julia-mode)

(use-package lsp-julia
  :straight
  (lsp-julia :type git :host github :repo "non-Jedi/lsp-julia" :files ("*.*" "languageserver"))
  :init
  (add-hook 'julia-mode-hook #'lsp)
  )

(provide 'init-julia)
