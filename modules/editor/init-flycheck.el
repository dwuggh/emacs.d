
(use-package flycheck
  :config
  (global-flycheck-mode 1)
  )

(dwuggh/leader-def
 "e" '(consult-flycheck :wk "flycheck errors")
 )


(provide 'init-flycheck)
