;;; -*- lexical-binding: t; -*-


(use-package evil-magit
  :defer t
  )

(use-package magit
  :defer t
  :config
  (require 'evil-magit)
  )

(dwuggh/leader-def
  "gs" 'magit-status
  )

(provide 'init-git)
