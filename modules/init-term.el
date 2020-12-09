
(use-package vterm)

(setq explicit-bash-args (cdr explicit-bash-args))

(defun my-vterm-set-cursor-after-update (&rest args)
  (if (equal evil-state 'insert)
	(setq-local cursor-type '(bar . 2))
	(setq-local cursor-type t)
	)
  )

(defun my-vterm-disable-sis-context-mode (&rest args)
  (sis-context-mode -1)
  )

(advice-add 'vterm--update :after
			'my-vterm-set-cursor-after-update
			)

(add-hook 'vterm-mode-hook #'my-vterm-disable-sis-context-mode)

(provide 'init-term)
