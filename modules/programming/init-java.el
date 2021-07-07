
(use-package lsp-java
  :defer t
  :init
  ;; (add-hook 'java-mode-hook (lambda ()
  ;;                  (require 'lsp-java)
  ;;                  (lsp)))
  (setq lsp-java-workspace-dir (concat my-cache-dir "lsp/workspace/"))
  (add-hook 'java-mode-hook #'my-lsp-init)
  )


(provide 'init-java)
