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

(dwuggh/leader-def
 ;; "fr" '(counsel-recentf :wk "find recent files")
 "pf" '(counsel-projectile-find-file :wk "find files in project")
 "pp" '(counsel-projectile-switch-project :wk "find files in project")
 )

(provide 'init-projects)
