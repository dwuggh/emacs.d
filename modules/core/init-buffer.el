;;; --- description -*- lexical-binding: t; -*-

(dwuggh/leader-def
 "TAB" '(evil-switch-to-windows-last-buffer :wk "last buffer")
 "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :wk "message buffer")
 "bs" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :wk "switch to scratch buffer")
 ;; "bb" '(counsel-buffer-or-recentf)
 )


(provide 'init-buffer)
;;; init-buffer.el ends here
