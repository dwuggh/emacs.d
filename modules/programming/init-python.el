
(use-package lsp-pyright
  :defer t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  )
(provide 'init-python)
