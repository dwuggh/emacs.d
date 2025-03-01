;; -*- lexical-binding: t; -*-

(require 'lib-hack)


(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-symbol-word-search t
        evil-search-module 'evil-search
        evil-undo-system 'undo-fu
        evil-ex-search-vim-style-regexp t
        evil-want-Y-yank-to-eol t
        )
  :config
  (evil-mode 1)
  (setq evil-goto-definition-functions
        '(evil-goto-definition-xref
          evil-goto-definition-imenu
          evil-goto-definition-semantic
          evil-goto-definition-search
          ))
  (defun evil-ex-search-word (&optional symbol)
    (interactive (list evil-symbol-word-search))
    (evil-ex-start-word-search nil 'forward 0 symbol))
  (evil-global-set-key 'normal (kbd "C-8") #'evil-ex-search-word)
  (evil-global-set-key 'normal (kbd "C-q") #'evil-ex-search-word)
  (evil-global-set-key 'insert (kbd "C-a") #'evil-beginning-of-line)
  (evil-global-set-key 'insert (kbd "C-q") #'evil-end-of-line)
  (evil-global-set-key 'normal (kbd "C-w /") #'evil-window-vsplit)
  (evil-global-set-key 'normal (kbd "C-w C-/") #'evil-window-vsplit)
  (evil-global-set-key 'normal (kbd "C-w m") #'toggle-maximize-buffer)

  ;; ;; TODO put this in autoloads
  ;; (evil-define-command +tabs:next-or-goto (index)
  ;;   "Switch to the next tab, or to INDEXth tab if a count is given."
  ;;   (interactive "<c>")
  ;;   (if index
  ;;       (centaur-tabs-select-visible-nth-tab index)
  ;;     (centaur-tabs-forward)))

  ;; (evil-define-command +tabs:previous-or-goto (index)
  ;;   "Switch to the previous tab, or to INDEXth tab if a count is given."
  ;;   (interactive "<c>")
  ;;   (if index
  ;;       (centaur-tabs-select-visible-nth-tab index)
  ;;     (centaur-tabs-backward)))
  (general-def
    :states 'normal
    :keymaps 'override
    "gh" 'tab-line-switch-to-prev-tab
    "gl" 'tab-line-switch-to-next-tab
    )
  (defun my/evil-lookup-func ()
    (interactive)
    (cond
     ((bound-and-true-p lspce-mode) (lspce-help-at-point))
     ((bound-and-true-p lsp-proxy-mode) (lsp-proxy-hover-at-point))
     ((eq major-mode 'emacs-lisp-mode) (helpful-at-point))
     (t (woman))))
  (setq evil-lookup-func 'my/evil-lookup-func)
  (general-def
    :keymaps 'override
    :states '(normal visual motion)
    "j" 'evil-next-visual-line
    "k" 'evil-previous-visual-line
    "gj" 'evil-next-line
    "gk" 'evil-previous-line
    "gr" 'xref-find-references
    "gt" 'lsp-proxy-find-type-definition
    "gy" 'xref-find-implementations
    )
  (dwuggh/leader-def
    "sc" '(evil-ex-nohighlight :wk "clear highlight"))
  )

(use-package xref
  :ensure nil
  :config
  (setq xref-prompt-for-identifier
        '(not
          xref-find-definitions xref-find-definitions-other-window
          xref-find-definitions-other-frame
          xref-find-references
          xref-find-implementations
          xref-find-type-definition
          ))
  )

(use-package evil-terminal-cursor-changer
  :after evil
  :config
  (unless (display-graphic-p)
    (require 'evil-terminal-cursor-changer)
    (evil-terminal-cursor-changer-activate) ; or (etcc-on)
    )
  )

(use-package undo-fu
  :init
  ;; (global-undo-tree-mode -1)
  (setq undo-limit 8000000
        undo-strong-limit 8000000
        undo-outer-limit 8000000)
  )
;; from doom emacs
(define-minor-mode undo-fu-mode
  "Enables `undo-fu' for the current session."
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map [remap undo] #'undo-fu-only-undo)
            (define-key map [remap redo] #'undo-fu-only-redo)
            (define-key map (kbd "C-_")     #'undo-fu-only-undo)
            (define-key map (kbd "M-_")     #'undo-fu-only-redo)
            (define-key map (kbd "C-M-_")   #'undo-fu-only-redo-all)
            (define-key map (kbd "C-x r u") #'undo-fu-session-save)
            (define-key map (kbd "C-x r U") #'undo-fu-session-recover)
            map)
  :init-value nil
  :global t)
(undo-fu-mode 1)


(use-package evil-collection
  ;; :custom (evil-collection-setup-minibuffer t)
  :init
  (setq evil-collection-setup-minibuffer nil)
  :config
  (evil-collection-init)
  )

(use-package evil-escape
  :ensure (evil-escape :type git :host github :repo "hlissner/evil-escape")
  ;; :defer t
  :config
  (setq evil-escape-key-sequence "jk"
        evil-escape-delay 0.05
        evil-escape-unordered-key-sequence t)
  ;; (add-hook 'evil-normal-state-exit-hook
  ;;           (lambda () (require 'evil-escape)))
  ;; (add-hook 'window-configuration-change-hook
  ;;           (lambda () (require 'evil-escape)))
  (evil-escape-mode)
  )

(use-package evil-snipe
  :after evil
  :config
  (general-def
    :states 'motion
    :keymaps 'override
    "'" 'evil-snipe-repeat-reverse)
  (evil-define-key 'motion evil-snipe-override-mode-map "," nil)
  (evil-define-key 'motion evil-snipe-override-local-mode-map "," nil)
  (evil-define-key 'motion evil-snipe-parent-transient-map "," nil)
  (evil-snipe-mode 1)
  (evil-snipe-override-mode 1)
  ;; (evil-snipe-local-mode 1)
  (setq evil-snipe-smart-case t
        evil-snipe-scope 'whole-visible)
  )

(use-package evil-nerd-commenter
  :after evil
  :config
  (general-def
    :states '(normal visual)
    :keymaps 'override
    ",/" '(evilnc-comment-or-uncomment-lines :wk "toggle comment lines")
    "M-;" '(evilnc-comment-or-uncomment-lines :wk "toggle comment lines")
    )
  (evil-define-key 'normal prog-mode-map "gc" 'evilnc-comment-operator)
  )


(use-package evil-matchit
  :config
  (setq evilmi-shortcut "m")
  (global-evil-matchit-mode 1)
  ;; (general-def :keymaps 'override "m" 'evilmi-jump-items)
  )

(use-package evil-surround
  :init
  (evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
  (evil-define-key 'visual evil-surround-mode-map "S" 'evil-substitute)
  (global-evil-surround-mode 1)
  )

(use-package evil-goggles
  :init
  (setq evil-goggles-duration 0.1
        evil-goggles-pulse t ; too slow
        ;; evil-goggles provides a good indicator of what has been affected.
        ;; delete/change is obvious, so I'd rather disable it for these.
        evil-goggles-enable-delete nil
        evil-goggles-enable-change nil)
  :config
  (evil-goggles-mode 1)
  (pushnew! evil-goggles--commands
            '(evil-magit-yank-whole-line
              :face evil-goggles-yank-face
              :switch evil-goggles-enable-yank
              :advice evil-goggles--generic-async-advice)
            '(+evil:yank-unindented
              :face evil-goggles-yank-face
              :switch evil-goggles-enable-yank
              :advice evil-goggles--generic-async-advice)
            '(+eval:region
              :face evil-goggles-yank-face
              :switch evil-goggles-enable-yank
              :advice evil-goggles--generic-async-advice))
  )

(use-package evil-lion
  :config
  (evil-lion-mode)
  )


(use-package evil-mark-replace
  :after evil
  )

(use-package evil-mc
  :after evil
  )

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 "C-u" 'evil-scroll-up
 "C-l" 'evil-scroll-line-to-center
 )
(general-define-key
 :states 'insert
 :keymaps 'override
 "C-V" 'evil-paste-before
 "C-l" 'evil-scroll-line-to-center
 )

(dwuggh/leader-def
  "c SPC" '(evilnc-quick-comment-or-uncomment-lines :wk "comment or uncomment line" )
  "cl" '(evilnc-quick-comment-or-uncomment-to-the-line :wk "comment or uncomment line" )
  "cp" '(evilnc-comment-or-uncomment-paragraphs  :wk  "comment or uncomment paragraph" )
  )
;; (add-hook 'evil-mode-hook
;;           (progn
;;             (evil-escape-mode)
;;             (evil-matchit-mode)
;;             (evil-snipe-mode)
;;             ))


(provide 'init-evil)
