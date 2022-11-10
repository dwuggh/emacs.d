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
  (defun evil-ex-search-word (&optional symbol)
    (interactive (list evil-symbol-word-search))
    (evil-ex-start-word-search nil 'forward 0 symbol)
    )
  (evil-global-set-key 'normal (kbd "C-8") #'evil-ex-search-word)
  (dwuggh/leader-def
    "sc" '(evil-ex-nohighlight :wk "clear highlight"))
  (general-def
    :keymaps 'override
    :states '(normal visual motion)
    "j" 'evil-next-visual-line
    "k" 'evil-previous-visual-line
    "gj" 'evil-next-line
    "gk" 'evil-previous-line
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
  :straight (evil-escape :type git :host github :repo "hlissner/evil-escape")
  ;; :defer t
  :config
  (setq evil-escape-key-sequence "jk"
        evil-escape-delay 0.15
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
        evil-snipe-scope 'line)
  )

(use-package evil-nerd-commenter
  :after evil
  :config
  (general-def
    :states '(normal visual)
    :keymaps 'override
    ",/" '(evilnc-comment-or-uncomment-lines :wk "toggle comment lines"))
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
   "ll" '(evilnc-quick-comment-or-uncomment-to-the-line :wk "comment or uncomment line" )
   "cp" '(evilnc-comment-or-uncomment-paragraphs  :wk  "comment or uncomment paragraph" )
 )
;; (add-hook 'evil-mode-hook
;;           (progn
;;             (evil-escape-mode)
;;             (evil-matchit-mode)
;;             (evil-snipe-mode)
;;             ))


(provide 'init-evil)
