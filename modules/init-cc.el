
(setq c-basic-offset 4)




(use-package cmake-mode
  ;; :config
  ;; (add-hook 'cmake-mode-hook #'my-lsp-init)
  )

(use-package cmake-ide
  :defer t
  :init
  ;; (add-hook+ (c-mode-hook c++-mode-hook)
  ;;         cide-mode-hook 'append)
  (setq cmake-ide-build-dir "build")
  ;; (add-hook+ (c-mode-hook c++-mode-hook) cmake-ide-setup)
  (dwuggh/localleader-def
   :keymaps '(c-mode-map cc-mode-map c++-mode-map)
   "cc" 'cmake-ide-compile
   "pc" 'cmake-ide-run-cmake
   "pC" 'cmake-ide-maybe-run-cmake
   "pd" 'cmake-ide-delete-file
   )
  )

(use-package flycheck-clang-tidy
  :after flycheck
  :init
  (add-hook 'global-flycheck-mode #'flycheck-clang-tidy-setup)
  )



(provide 'init-cc)
