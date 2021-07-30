;; -*- lexical-binding: t; -*-


(use-package projectile
  :init
  (setq projectile-sort-order 'recentf
    projectile-cache-file (concat my-cache-dir "projectile.cache")
    projectile-known-projects-file (expand-file-name (concat my-cache-dir "projectile-bookmarks.eld"))
    )
  :config
  (projectile-global-mode 1)
  )

(use-package counsel-projectile)

(defun switch-to-emacs-config ()
  "switch to .emacs.d"
  (interactive)
  (counsel-projectile-switch-project-action "~/.emacs.d")
  )

(defun switch-to-init.el ()
  "switch to emacs' init.el"
  (interactive)
  (switch-to-buffer (find-file-noselect (concat user-emacs-directory "init.el") nil nil)))

(dwuggh/leader-def
 ;; "fr" '(counsel-recentf :wk "find recent files")
 "pf" '(counsel-projectile-find-file :wk "find files in project")
 "pp" '(counsel-projectile-switch-project :wk "find files in project")
 "pe" 'switch-to-emacs-config
 "pi" 'switch-to-init.el
 )

(provide 'init-projects)
