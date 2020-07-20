;; -*- lexical-binding: t; -*-


(use-package projectile
  :defer t
  )

(use-package counsel-projectile
  :defer t
  )

(dwuggh/leader-def
 ;; "fr" '(counsel-recentf :wk "find recent files")
 "pf" '(counsel-projectile-find-file :wk "find files in project")
 "pp" '(counsel-projectile-switch-project :wk "find files in project")
 )

(provide 'init-projects)
