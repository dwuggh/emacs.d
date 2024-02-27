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

;; https://www.reddit.com/r/emacs/comments/1937vaz/emacs_291_on_windows_install_magit_requires_seq/
;; (defun +elpaca-unload-seq (e)
;;   (and (featurep 'seq) (unload-feature 'seq t))
;;   (elpaca--continue-build e))

;; (defun +elpaca-seq-build-steps ()
;;   (append (butlast (if (file-exists-p (expand-file-name "seq" elpaca-builds-directory))
;;                        elpaca--pre-built-steps elpaca-build-steps))
;;           (list '+elpaca-unload-seq 'elpaca--activate-package)))

;; (use-package seq :elpaca `(seq :build ,(+elpaca-seq-build-steps)))
(use-package magit
  ;; :after seq
  :init
  (dwuggh/leader-def
  "gs" 'magit-status
  "gf" 'magit-file-dispatch
  )
  
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
  :after git-gutter
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224]
          nil nil '(center repeated))
        (define-fringe-bitmap 'git-gutter-fr:modified [224]
          nil nil '(center repeated))
        (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240]
          nil nil 'bottom)
  )

(use-package blamer
  :elpaca (blamer :type git :host github :repo "artawower/blamer.el")
  :defer
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 130
                    :italic t)))
  :config
  (setq blamer-max-commit-message-length 50
        blamer-min-offset 60
        blamer-idle-time 0.8
        blamer-avatar-size 80
        )
  ;; (setq blamer-commit-formatter " ● %s")
  ;; (global-blamer-mode 1)
  )



(provide 'init-git)
