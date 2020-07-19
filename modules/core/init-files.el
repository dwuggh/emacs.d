;;; -*- lexical-binding: t; -*-

(use-package recentf
  :init
  (recentf-mode t)
  )

(dwuggh/leader-def
 "fr" '(counsel-recentf :wk "find recent files")
 "ff" '(counsel-find-file :wk "find files in current dir")
 "fs" '(save-buffer :wk "save file")
 )

(provide 'init-files)
