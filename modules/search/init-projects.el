;; -*- lexical-binding: t; -*-

(setq project-list-file (concat my-cache-dir "projects"))

(use-package consult-project-extra)
(use-package treemacs
  :defer t
  :init
  (dwuggh/leader-def
    "ft" 'treemacs
    "t"  'window-toggle-side-windows
    )
   :config
  (progn
    (setq treemacs-collapse-dirs                   (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay        0.5
          treemacs-directory-name-transformer      #'identity
          treemacs-display-in-side-window          t
          treemacs-eldoc-display                   'simple
          treemacs-file-event-delay                2000
          treemacs-file-extension-regex            treemacs-last-period-regex-value
          treemacs-file-follow-delay               0.2
          treemacs-file-name-transformer           #'identity
          treemacs-follow-after-init               t
          treemacs-expand-after-init               t
          treemacs-find-workspace-method           'find-for-file-or-pick-first
          treemacs-git-command-pipe                ""
          treemacs-goto-tag-strategy               'refetch-index
          treemacs-header-scroll-indicators        '(nil . "^^^^^^")
          treemacs-hide-dot-git-directory          t
          treemacs-indentation                     2
          treemacs-indentation-string              " "
          treemacs-is-never-other-window           nil
          treemacs-max-git-entries                 5000
          treemacs-missing-project-action          'ask
          treemacs-move-forward-on-expand          nil
          treemacs-no-png-images                   nil
          treemacs-no-delete-other-windows         t
          treemacs-project-follow-cleanup          nil
          treemacs-persist-file                    (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                        'left
          treemacs-read-string-input               'from-child-frame
          treemacs-recenter-distance               0.1
          treemacs-recenter-after-file-follow      nil
          treemacs-recenter-after-tag-follow       nil
          treemacs-recenter-after-project-jump     'always
          treemacs-recenter-after-project-expand   'on-distance
          treemacs-litter-directories              '("/node_modules" "/.venv" "/.cask")
          treemacs-project-follow-into-home        nil
          treemacs-show-cursor                     nil
          treemacs-show-hidden-files               t
          treemacs-silent-filewatch                nil
          treemacs-silent-refresh                  nil
          treemacs-sorting                         'alphabetic-asc
          treemacs-select-when-already-in-treemacs 'move-back
          treemacs-space-between-root-nodes        t
          treemacs-tag-follow-cleanup              t
          treemacs-tag-follow-delay                1.5
          treemacs-text-scale                      nil
          treemacs-user-mode-line-format           nil
          treemacs-user-header-line-format         nil
          treemacs-wide-toggle-width               70
          treemacs-width                           35
          treemacs-width-increment                 1
          treemacs-width-is-initially-locked       t
          treemacs-workspace-switch-cleanup        nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (when treemacs-python-executable
      (treemacs-git-commit-diff-mode t))

    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple)))

    (treemacs-hide-gitignored-files-mode nil)
    ;; turn off modeline in treemacs buffer
    )
  )

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package treemacs-magit
  :after (treemacs magit))


;; TODO potential alternatives: curly.el + bufler.el
(use-package persp-mode
  :hook (window-setup . persp-mode)
  :init
  ;; (setq wg-morph-on nil)
  (setq
   persp-save-dir (concat my-cache-dir "persp-workspaces/")
   persp-auto-resume-time -1 ; Don't auto-load on startup
   persp-auto-save-opt 1
   persp-autokill-buffer-on-remove 'kill-weak
   )
  )

(use-package treemacs-persp
  :after (treemacs persp-mode) 
  :config (treemacs-set-scope-type 'Perspectives)
  )

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
