;;; -*- lexical-binding: t; -*-

(use-package recentf
  :init
  (setq recentf-save-file (concat user-emacs-directory ".cache/recentf")
		recentf-max-saved-items 2000
		recentf-max-menu-items 2000
		)
  (recentf-mode t)
  )

(use-package rg)

(dwuggh/leader-def
 "fr" '(counsel-recentf :wk "find recent files")
 "ff" '(counsel-find-file :wk "find files in current dir")
 "fs" '(save-buffer :wk "save file")
 "fS" '(evil-write-all :wk "save all file")
 "fz" 'counsel-fzf
 )

(provide 'init-files)
