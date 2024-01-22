;;; -*- lexical-binding: t; -*-


(setq vc-follow-symlinks t)

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
(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224]
          nil nil '(center repeated))
        (define-fringe-bitmap 'git-gutter-fr:modified [224]
          nil nil '(center repeated))
        (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240]
          nil nil 'bottom)
  )

(use-package blamer
  :straight (blamer :type git :host github :repo "artawower/blamer.el")
  :defer 20
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (setq blamer-max-commit-message-length 50
        blamer-min-offset 60
        blamer-idle-time 0.3
        )
  
  ;; (global-blamer-mode 1)
  )

(dwuggh/leader-def
  "gs" 'magit-status
  "gf" 'magit-file-dispatch
  )


(provide 'init-git)
