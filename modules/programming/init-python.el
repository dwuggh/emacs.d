(use-package conda
  :init
  (setq conda-anaconda-home "/opt/miniconda"
        conda-env-home-directory (expand-file-name "~/.conda/")
        )
  :config
  ;; (conda-env-autoactivate-mode 1)
  ;; (conda-env-activate "base")
  )

(use-package lsp-pyright
  :after lsp)

(dwuggh/localleader-def
  :keymaps '(python-mode-map)
  :states '(normal visual)
  "sb" 'python-shell-send-buffer
  "sg" 'python-shell-send-file
  "sf" 'python-shell-send-defun
  "sr" 'python-shell-send-region
  )

(provide 'init-python)
