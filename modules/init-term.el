
(use-package vterm)

(setq explicit-bash-args (cdr explicit-bash-args))

(defun my-vterm-set-cursor-after-update (&rest args)
  (if (equal evil-state 'insert)
	(setq-local cursor-type '(bar . 2))
	(setq-local cursor-type t)
	)
  )


(advice-add 'vterm--update :after
			'my-vterm-set-cursor-after-update
			)
(provide 'init-term)
