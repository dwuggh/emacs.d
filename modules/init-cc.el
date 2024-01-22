
(setq c-basic-offset 4)


(use-package cmake-mode
  ;; :config
  )

(use-package flycheck-clang-tidy
  :after flycheck
  :init
  (add-hook 'global-flycheck-mode #'flycheck-clang-tidy-setup)
  )



(provide 'init-cc)
