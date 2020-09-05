
(use-package wucuo
  :defer t
  )

(general-add-hook
 '(text-mode-hook org-mode-hook)
 #'wucuo-start)

(provide 'init-spell)
