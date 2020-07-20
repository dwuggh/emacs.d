;;; -*- lexical-binding: t; -*-

(require 'lib-hack)
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
  ;; don't create a pair with single quote in minibuffer
  ;; (sp-local-pair 'minibuffer-inactive-mode "'" nil :actions nil)
  )


;;; company configuration
;;; -----------------------------------------------------------------------------
(use-package company
  ;; :defer t
  :config
  (setq
   company-selection-wrap-around nil
   company-show-numbers nil
   company-idle-delay 0.08
   company-require-match 'never
   company-minimum-prefix-length 2
   company-auto-complete-chars '(?\))
   company-auto-complete nil
   ;; fuck, why this could even change???
   company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                       company-echo-metadata-frontend
                       company-preview-if-just-one-frontend)
   )
  (define-key company-active-map (kbd "C-j") 'company-select-next)
  (define-key company-active-map (kbd "C-k") 'company-select-previous)
  (define-key company-active-map (kbd "C-l") 'company-complete-selection)
  (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "<tab>") 'company-complete-common-or-cycle)
  (define-key company-active-map (kbd "RET") 'company-complete-selection)
  (let ((prev nil))
    (defun spacemacs//set-C-k-company-select-previous (&rest args)
      (setf prev (lookup-key evil-insert-state-map (kbd "C-k")))
      (define-key evil-insert-state-map (kbd "C-k") 'company-select-previous))
    (defun spacemacs//restore-C-k-evil-insert-digraph (&rest args)
      (define-key evil-insert-state-map (kbd "C-k") prev)))
  (add-hook 'company-completion-started-hook 'spacemacs//set-C-k-company-select-previous)
  (add-hook 'company-completion-finished-hook 'spacemacs//restore-C-k-evil-insert-digraph)
  (add-hook 'company-completion-cancelled-hook 'spacemacs//restore-C-k-evil-insert-digraph)

  (global-company-mode)
  )

(use-package company-quickhelp
  :config
  (company-quickhelp-mode))



(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package company-box
  ;; :hook (company-mode . company-box-mode)
  )

(use-package posframe)
(use-package company-posframe
  :config
  (setq company-posframe-quickhelp-delay 0.3)
  (company-posframe-mode 1)
  (general-define-key :keymap company-posframe-active-map
		      :states 'insert
		      "C-f" 'company-posframe-quickhelp-toggle
		      "C-n" 'company-posframe-quickhelp-scroll-up
		      "C-p" 'company-posframe-quickhelp-scroll-down
		      )
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-f") 'company-posframe-quickhelp-toggle)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-f") 'company-show-doc-buffer)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-n") 'company-posframe-quickhelp-scroll-down)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-p") 'company-posframe-quickhelp-scroll-up)
  )


;; backend
(setq-default company-backends
      '((company-capf company-dabbrev-code :with company-yasnippet) company-dabbrev))



;;; highlights
;;; TODO autoload
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
