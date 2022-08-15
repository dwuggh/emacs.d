(use-package lsp-bridge
  :straight
  (lsp-bridge :type git :host github :repo "manateelazycat/lsp-bridge"
              :files ("*"))
  :init
  (setq lsp-bridge-python-command "/usr/bin/python")
  :config
  (require 'lsp-bridge)
  (global-lsp-bridge-mode)
  (define-key acm-mode-map (kbd "C-j") 'acm-select-next)
  (define-key acm-mode-map (kbd "C-k") 'acm-select-prev)
  (define-key evil-insert-state-map (kbd "C-k") nil)


  ;; (defun my-lsp-bridge-toggle-doc ()
  ;;   (interactive)
  ;;   )

  (evil-define-key* '(normal visual) lsp-bridge-mode-map (kbd "K") #'lsp-bridge-lookup-documentation)
  )

(defun my-lsp-init ()
  "My lsp initialization."
  )

(provide 'init-lsp-bridge)
