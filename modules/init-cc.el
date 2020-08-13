
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

(defun lsp-clangd-switch-between-source-headers ()
  "switch between header and source file using clangd."
  (interactive)
  (let* ((resp (lsp-request
		"textDocument/switchSourceHeader"
		(lsp--text-document-identifier)))
	 (filename (if (string-prefix-p "file:\/\/" resp)
		       (substring resp 7 nil)
		     resp)))
    (if (not (equal "" filename))
	(switch-to-buffer (find-file-noselect filename))
      (message "didn't find file"))))

(dwuggh/localleader-def
 :keymaps '(c-mode-map c++-mode-map)
 "gh" 'lsp-clangd-switch-between-source-headers
 )
;; data.items
(provide 'init-cc)
