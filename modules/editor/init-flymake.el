
(use-package flymake
  :hook ((prog-mode text-mode) . flymake-mode)
  :config
  (setq flymake-fringe-indicator-position 'right-fringe
        flymake-run-in-place nil
        )
  )

(use-package flymake-popon
  :hook (flymake-mode . flymake-popon-mode)
  :config
  (setq flymake-popon-method 'posframe)
  )

(provide 'init-flymake)
