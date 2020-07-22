
(use-package wucuo
  :defer t
  )

(general-add-hook
 '(prog-mode-hook text-mode-hook)
 #'wucuo-start)

(provide 'init-spell)
