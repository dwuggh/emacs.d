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
  )

(use-package posframe)

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
  (setq company-backends
        '((company-capf company-dabbrev-code) company-dabbrev))
  

  (global-company-mode)
  )


(use-package company-posframe
  :config
  (company-posframe-mode 1)
  )

(general-def
 :states '(normal visual motion)
 :keymaps 'override
 "C-q" 'evil-end-of-line)



(provide 'init-editor)
;;; init-editor.el ends here
