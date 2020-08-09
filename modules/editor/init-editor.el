;;; -*- lexical-binding: t; -*-


(require 'lib-hack)
(require 'init-leader)
(require 'init-evil)
(require 'init-fold)

(require 'init-window)
(require 'init-company)
(require 'init-flycheck)

(setq-default make-backup-files nil)
(setq-default scroll-conservatively 101)
(setq-default display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

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



(provide 'init-editor)
;;; init-editor.el ends here
