;; -*- lexical-binding: t; -*-

(setq project-list-file (concat my-cache-dir "projects"))

(use-package projectile
  :init
  :config
  (setq projectile-sort-order 'recentf
    projectile-cache-file (concat my-cache-dir "projectile.cache")
    projectile-known-projects-file (expand-file-name (concat my-cache-dir "projectile-bookmarks.eld"))
    projectile-project-root-files (append '("xmake.lua" ".project") projectile-project-root-files)
    )
  (projectile-global-mode 1)
  )

(defun switch-to-emacs-config ()
  "switch to .emacs.d"
  (interactive)
  ;; (project-find-file-in "~/.emacs.d")
  (projectile-find-file-in-directory user-emacs-directory)
  )

(defun switch-to-init.el ()
  "switch to emacs' init.el"
  (interactive)
  (switch-to-buffer (find-file-noselect (f-join user-emacs-directory "init.el") nil nil)))

(dwuggh/leader-def
 "pf" 'project-find-file
 "pr" 'project-find-regexp
 "pp" '(projectile-switch-project :wk "find files in project")
 "pe" 'switch-to-emacs-config
 "pi" 'switch-to-init.el
 )

(provide 'init-projects)
