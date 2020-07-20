;; -*- lexical-binding: t; -*-


(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-symbol-word-search t)
  :config
  (evil-mode 1)
  )

(use-package evil-collection
  ;; :custom (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))

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
        evil-snipe-scope 'whole-buffer)
  )

(use-package evil-nerd-commenter
  :after evil
  :config
  (general-def
    :states '(normal visual)
    :keymaps 'override
    ",/" '(evilnc-comment-or-uncomment-lines :wk "toggle comment lines"))
  )

;; TODO temp location
(dwuggh/leader-def
   "c SPC" '(evilnc-quick-comment-or-uncomment-lines :wk "comment or uncomment line" )
   "cl" '(evilnc-quick-comment-or-uncomment-to-the-line :wk "comment or uncomment line" )
   "ll" '(evilnc-quick-comment-or-uncomment-to-the-line :wk "comment or uncomment line" )
   "cp" '(evilnc-comment-or-uncomment-paragraphs  :wk  "comment or uncomment paragraph" )
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



(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 "C-u" 'evil-scroll-up
 )
;; (add-hook 'evil-mode-hook
;;           (progn
;;             (evil-escape-mode)
;;             (evil-matchit-mode)
;;             (evil-snipe-mode)
;;             ))


(provide 'init-evil)
