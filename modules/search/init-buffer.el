;;; --- description -*- lexical-binding: t; -*-

(use-package bufler
  :init (setq bufler-workspace-mode-lighter "")
  )

(dwuggh/leader-def
 "TAB" '(evil-switch-to-windows-last-buffer :wk "last buffer")
 "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :wk "message buffer")
 "bs" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :wk "switch to scratch buffer")
 ;; "bb" '(counsel-buffer-or-recentf)
 "bb" '(consult-buffer :wk "switch buffer")
 "bl" '(bufler-switch-buffer :wk "bufler")
 )


(provide 'init-buffer)
;;; init-buffer.el ends here
