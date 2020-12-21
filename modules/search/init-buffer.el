;;; --- description -*- lexical-binding: t; -*-

(dwuggh/leader-def
 "TAB" '(evil-switch-to-windows-last-buffer :wk "last buffer")
 "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :wk "message buffer")
 "bs" '((lambda () (interactive) (switch-to-buffer "*scratch*")) :wk "switch to scratch buffer")
 ;; "bb" '(counsel-buffer-or-recentf)
 "bb" '(ivy-switch-buffer :wk "change buffer")
 )

(define-key ivy-switch-buffer-map (kbd "C-k") 'ivy-previous-line)
(define-key ivy-switch-buffer-map (kbd "C-l") 'ivy-switch-buffer-kill)

(provide 'init-buffer)
;;; init-buffer.el ends here
