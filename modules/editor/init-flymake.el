
(use-package flymake
  ;; :ensure (flymake :host github :repo "flymake/emacs-flymake")
  :hook ((prog-mode text-mode) . flymake-mode)
  :config
  (setq flymake-fringe-indicator-position 'right-fringe
        flymake-run-in-place nil
        )
  (with-eval-after-load
      'rust-ts-mode
      (setq auto-mode-alist (delete '("\\.rs\\'" . rust-ts-mode) auto-mode-alist))
      (setq rust-ts-flymake-command '("cargo" "clippy"))
      (defun remove-rust-ts-flymake ()
        (remove-hook 'flymake-diagnostic-functions 'rust-ts-flymake t))
      (add-hook 'rust-ts-mode-hook 'remove-rust-ts-flymake)
      )
  (dwuggh/leader-def
    "se" '(consult-flymake :wk "consult errors")
    "e" '(consult-flymake :wk "consult errors")
    )
  )

(use-package flymake-popon
  :hook (flymake-mode . flymake-popon-mode)
  :config
  (setq flymake-popon-method 'posframe)
  )

(provide 'init-flymake)
