;;; -*- lexical-binding: t; -*-


(use-package recentf
  :init
  (setq recentf-save-file (concat user-emacs-directory ".cache/recentf")
        recentf-max-saved-items 2000
        recentf-max-menu-items 2000
        )
  (recentf-mode t)
  )

(use-package sync-recentf
  :straight
  (sync-recentf :type git :host github
         :repo "ffevotte/sync-recentf")
  :init
  (setq recentf-auto-cleanup 60)
  )

(use-package rg)

(defun xdg-open-file-1 (file)
  "Open FILE with xdg-open."
  (call-process "xdg-open" nil 0 nil file)
  )

(defun xdg-open-file (&optional initial-input)
  "Open selected file with xdg-open.
When INITIAL-INPUT is non-nil, use it in the minibuffer during completion."
  (interactive)
  (counsel--find-file-1
   "xdg-open file: " initial-input
   #'xdg-open-file-1
   'my-xdg-open
   )
  )


(dwuggh/leader-def
 "fr" '(consult-recent-file :wk "find recent files")
 "ff" '(counsel-find-file :wk "find files in current dir")
 "fs" '(save-buffer :wk "save file")
 "fS" '(evil-write-all :wk "save all file")
 "fz" 'counsel-fzf
 )

(provide 'init-files)
