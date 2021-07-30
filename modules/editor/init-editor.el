;;; -*- lexical-binding: t; -*-


(require 'lib-hack)
(require 'init-leader)
(require 'init-evil)
(require 'init-fold)

(require 'init-window)
(require 'init-company)
(require 'init-flycheck)

(setq-default make-backup-files nil
          auto-save-default nil
          auto-save-list-file-prefix (concat my-cache-dir "auto-save-list/.saves-"))
(setq create-lockfiles nil)
(setq-default indent-tabs-mode nil)


(use-package auto-save
  :straight (auto-save :type git
               :host github
               :repo "manateelazycat/auto-save"
               )
  :config
  (auto-save-enable)
  (setq
   auto-save-silent t
    auto-save-idle 10)
  )


(setq-default scroll-conservatively 101)
(setq-default display-line-numbers-type t)
(global-display-line-numbers-mode 1)


(defvar untabify-this-buffer t
  "If nonnil, activate `untabify-all'.")
(defun untabify-all ()
  "Untabify the current buffer, unless `untabify-this-buffer' is nil."
  (and untabify-this-buffer (untabify (point-min) (point-max))))
(define-minor-mode untabify-mode
  "Untabify buffer on save." nil " untab" nil
  (make-variable-buffer-local 'untabify-this-buffer)
  (setq untabify-this-buffer (not (derived-mode-p 'makefile-mode)))
  (add-hook 'before-save-hook #'untabify-all))
(add-hook 'prog-mode-hook 'untabify-mode)

;;; --------------------------------------------------------------------------------------

(use-package smartparens
  :defer t
  :commands (sp-split-sexp sp-newline sp-up-sexp)
  :init
  (setq sp-show-pair-delay 0.1
        sp-show-pair-from-inside t
        ;; from spacemacs, dit look up
        sp-cancel-autoskip-on-backward-movement nil
        sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil
        )
  (add-hook+ (prog-mode-hook comint-mode-hook)
             smartparens-mode)
  :config
  (require 'smartparens-config)
  (sp-with-modes
      'prog-mode
    (sp-local-pair "{" nil :post-handlers '(:add ("||\n[i]" "RET"))))
  (sp-with-modes
      'org-mode
    (sp-local-pair "$" "$")
    (sp-local-pair "=" "=")
    (sp-local-pair "*" "*")
    (sp-local-pair "\\[" "\\]")
    )
  ;; don't create a pair with single quote in minibuffer
  ;; (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  )

;;; narrow
(dwuggh/leader-def
  "n" '(:ignore t :wk "narrow")
  "nf" 'narrow-to-defun
  "np" 'narrow-to-page
  "nr" 'narrow-to-region
  "nw" 'widen
  )

;; a temporary way
(defun my-newline ()
  (interactive)
  (if (looking-back "{")
      (progn
    (newline)
    (newline)
    (indent-for-tab-command)
    (evil-previous-line)
    (indent-for-tab-command)
    )
    (newline)
    )
  )

;; (evil-global-set-key 'insert (kbd "RET") 'my-newline)

;; sync files with disk
(global-auto-revert-mode 1)

;;; highlights
;;; ---------------------------------------------------------------------------------------

(use-package highlight-parentheses
  :defer t
  :init
  (setq hl-paren-colors '("Springgreen3"
                          "IndianRed1"
                          "IndianRed3"
                          "IndianRed4"))
  (setq hl-paren-delay 0.1)

  :hook (prog-mode . highlight-parentheses-mode)
  :config
  (set-face-attribute 'hl-paren-face nil :weight 'ultra-bold)
  ;; (add-hook 'prog-mode-hook #'highlight-parentheses-mode)
  )

(use-package rainbow-delimiters
  ;; :defer t
  :hook (prog-mode . rainbow-delimiters-mode)
  ;; :config
  ;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  )

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode)
  ;; :config
  ;; (add-hook 'prog-mode-hook #'highlight-numbers-mode)
  )

;; TODO move to elsewhere
(use-package hl-todo
  :config
  (global-hl-todo-mode)
  (setq hl-todo-keyword-faces
        ;; from spacemacs
        '(("HOLD" . "#d0bf8f")
          ("TODO" . "#cc9393")
          ("NEXT" . "#dca3a3")
          ("THEM" . "#dc8cc3")
          ("PROG" . "#7cb8bb")
          ("OKAY" . "#7cb8bb")
          ("DONT" . "#5f7f5f")
          ("FAIL" . "#8c5353")
          ("DONE" . "#afd8af")
          ("NOTE" . "#d0bf8f")
          ("KLUDGE" . "#d0bf8f")
          ("HACK" . "#d0bf8f")
          ("TEMP" . "#d0bf8f")
          ("FIXME" . "#cc9393")
          ("XXX+" . "#cc9393")))
  (define-key hl-todo-mode-map (kbd "C-c p") 'hl-todo-previous)
  (define-key hl-todo-mode-map (kbd "C-c n") 'hl-todo-next)
  (define-key hl-todo-mode-map (kbd "C-c o") 'hl-todo-occur)
  (define-key hl-todo-mode-map (kbd "C-c i") 'hl-todo-insert)
  )


(general-def
 :states '(normal visual motion)
 :keymaps 'override
 "C-q" 'evil-end-of-line)

;; miscellaneous
(use-package crux)


(provide 'init-editor)
;;; init-editor.el ends here
