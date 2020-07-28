
(use-package treemacs
  :defer t
  :init
  (setq treemacs-follow-after-init t
        treemacs-is-never-other-window nil
        treemacs-sorting 'alphabetic-case-insensitive-asc
        treemacs-persist-file (concat my-cache-dir "treemacs-persist")
        treemacs-last-error-persist-file (concat my-cache-dir "treemacs-last-error-persist"))
  :config
  (treemacs-follow-mode -1)
  (delq 'treemacs-mode aw-ignored-buffers)
  (advice-add 'treemacs :after 'balance-windows-area)
  )

(use-package treemacs-evil
  :after treemacs
  :config
  (general-def evil-treemacs-state-map
    [return] #'treemacs-RET-action
    [tab]    #'treemacs-TAB-action
    "TAB"    #'treemacs-TAB-action
    ;; REVIEW Fix #1875 to be consistent with C-w {v,s}, but this should really
    ;;        be considered upstream.
    "o v"    #'treemacs-visit-node-horizontal-split
    "o s"    #'treemacs-visit-node-vertical-split
    )
  )

(use-package treemacs-projectile
  :after treemacs
  )

(use-package treemacs-magit
  :after treemacs magit
  )

(dwuggh/leader-def
  "ft" 'treemacs
  "0" 'treemacs-select-window)

;; (dwuggh/leader-def
;;   "ft" 'treemacs)
(provide 'init-treemacs)
