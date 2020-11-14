
(use-package lsp-pyright
  :defer t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp)))
  )

(use-package ein
  :config
  (setq org-babel-load-languages
		(cons '(ein . t) org-babel-load-languages))
  )

(provide 'init-python)
