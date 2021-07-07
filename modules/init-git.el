;;; -*- lexical-binding: t; -*-


(use-package evil-magit
  :defer t
  )

(use-package with-editor
  :defer t
  :config
  (general-def
    :keymaps 'with-editor-mode-map
    :states '(normal visual motion)
    ",," 'with-editor-finish
    ",k" 'with-editor-cancel
    )
  )
(use-package magit
  :defer t
  :config
  (require 'evil-magit)
  )

(use-package transient
  :defer t
  :init
  (setq
   transient-history-file (concat my-cache-dir "transient/history.el")
   transient-levels-file (concat my-cache-dir "transient/levels.el")
   transient-values-file (concat my-cache-dir "transient/values.el")
   ))

(use-package git-gutter
  :init
  ;; (setq git-gutter:deleted-sign "|")
  ;; (setq git-gutter:modified-sign "|")
  ;; (setq git-gutter:added-sign "|")
  :config
  (global-git-gutter-mode 1)
  )

;; (use-package git-gutter-fringe)

(dwuggh/leader-def
  "gs" 'magit-status
  "gf" 'magit-file-dispatch
  )


(provide 'init-git)
