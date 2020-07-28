;;; -*- lexical-binding: t; -*-


(use-package evil-magit
  :defer t
  )

(use-package magit
  :defer t
  :config
  (require 'evil-magit)
  )

(use-package transient
  :defer t
  :init
  (setq
   transient-history-file (concat my-cache-dir "transient/history.el")
   transient-levels-file (concat my-cache-dir "transient/levels.el")
   transient-values-file (concat my-cache-dir "transient/values.el")
   ))

(use-package git-gutter
  :config
  (global-git-gutter-mode 1))
(dwuggh/leader-def
  "gs" 'magit-status
  )

(provide 'init-git)
