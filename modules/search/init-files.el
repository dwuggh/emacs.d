;;; -*- lexical-binding: t; -*-

(use-package recentf
  :init
  (setq recentf-save-file (concat user-emacs-directory ".cache/recentf")
	recentf-max-saved-items 2000)
  (recentf-mode t)
  )

(dwuggh/leader-def
 "fr" '(counsel-recentf :wk "find recent files")
 "ff" '(counsel-find-file :wk "find files in current dir")
 "fs" '(save-buffer :wk "save file")
 )

(provide 'init-files)
