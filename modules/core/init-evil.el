;; -*- lexical-binding: t; -*-


(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1)
  )

(use-package evil-collection
  :after evil
  ;; :custom (evil-collection-setup-minibuffer t)
  :config
  (evil-collection-init))


(use-package evil-escape
  :init
  (setq-default evil-escape-key-sequence "jk"
                evil-escape-delay "0.1"
                evil-escape-unordered-key-sequence t)
  (evil-escape-mode)
  )

(use-package evil-snipe
  :config
  (general-def
    :states 'motion
    :keymaps 'override
    "'" 'evil-snipe-repeat-reverse)
  (evil-define-key 'motion evil-snipe-override-mode-map "," nil)
  (evil-define-key 'motion evil-snipe-override-local-mode-map "," nil)
  (evil-define-key 'motion evil-snipe-parent-transient-map "," nil)
  )

(use-package evil-nerd-commenter
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
  (global-evil-matchit-mode 1)
  (general-def :keymaps 'override "m" 'evilmi-jump-items)
  )

;; (add-hook 'evil-mode-hook
;;           (progn
;;             (evil-escape-mode)
;;             (evil-matchit-mode)
;;             (evil-snipe-mode)
;;             ))


(provide 'init-evil)
