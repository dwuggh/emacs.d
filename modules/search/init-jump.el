;;; -*- lexical-binding: t; -*-

(use-package avy
  :init
  (setq avy-timeout-seconds 0.2
        avy-all-windows t
        avy-background t)
  )

(dwuggh/leader-def
 "jj" '(evil-avy-goto-char-timer :wk "char timer")
 "jl" '(evil-avy-goto-line :wk "goto line")
 "jo" '(evil-avy-goto-line-above :wk "goto line above")
 "j." '(evil-avy-goto-line-below :wk "goto line below")
 "jw" '(evil-avy-goto-word-1 :wk "goto word")
 "jb" '(avy-pop-mark :wk "go back")
 )


(setq my-jump-handler-default '(
                lsp-find-definition
                ))

(defun my-navigation (&optional jump-handler)
  "Jump to definition around point using the best tool for this action.
`spacemacs/jump-to-definition'"
  (interactive)
  (catch 'done
    (let ((old-buffer (current-buffer))
          (old-point (point))
      (jump-handler (if jump-handler
                jump-handler
              my-jump-handler-default)))
      (dolist (-handler jump-handler)
        (let ((handler (if (listp -handler) (car -handler) -handler))
              (async (when (listp -handler)
                       (plist-get (cdr -handler) :async))))
          (ignore-errors
            (call-interactively handler))
          (when (or (eq async t)
                    (and (fboundp async) (funcall async))
                    (not (eq old-point (point)))
                    (not (equal old-buffer (current-buffer))))
            (throw 'done t)))))
    (message "No jump handler was able to find this symbol.")))

(dwuggh/localleader-def
 :keymaps 'prog-mode-map
 "gg" '(lsp-find-definition :wk "goto definition")
 )

(provide 'init-jump)
