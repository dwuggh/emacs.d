
;; (use-package ccls
;;   :defer t
;;   :init
;;   ;; (add-hook+ (c-mode-hook c++-mode-hook)
;;   ;; 	     lsp)
;;   ;; :config (push ".ccls-cache" projectile-globally-ignored-directories)
;;   )

(setq c-basic-offset 4)

(add-hook+ (c-mode-hook c++-mode-hook)
	     lsp)

(setq lsp-clients-clangd-args '(
				"--clang-tidy"
				"--completion-style=detailed"
				"--header-insertion=never"
				"--index"
				"--background-index"
				"--all-scopes-completion"
				"--cross-file-rename"
				))

;; (use-package ccls)

(use-package clang-format
  :defer t
  )

(use-package cmake-ide
  :defer t
  :init
  ;; (add-hook+ (c-mode-hook c++-mode-hook)
  ;; 	     cide-mode-hook 'append)
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

;; data.items
(provide 'init-cc)
