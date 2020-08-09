
(use-package vimish-fold
  :init
  (setq vimish-fold-dir (concat my-cache-dir "vimish/fold/")
	vimish-fold-header-width 90)
  (add-hook 'prog-mode-hook 'hs-minor-mode)
  )

(use-package evil-vimish-fold
  :defer t
  ;; :after vimish-fold
  ;; :hook ((prog-mode conf-mode text-mode) . evil-vimish-fold-mode)
  )

(provide 'init-fold)
