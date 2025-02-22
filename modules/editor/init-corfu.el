
(use-package corfu
  :init
  (global-corfu-mode)
  ;; :config
  (setq corfu-auto t
        corfu-auto-delay 0.04
        corfu-auto-prefix 1
        corfu-cycle t
        corfu-count 12
        corfu-max-width 160
        corfu-min-width 25
        ;; corfu-quit-no-match 'separator
        corfu-on-exact-match nil
        tab-always-indent 'complete
        corfu-preselect 'valid
        corfu-preview-current #'insert
        )
  (add-hook 'evil-insert-state-exit-hook #'corfu-quit)
  :config
  (add-hook 'corfu-mode-hook #'corfu-popupinfo-mode)
  (setq corfu-popupinfo-delay '(0.5 . 0.5))
  (setq text-mode-ispell-word-completion nil)
  (add-to-list 'completion-category-overrides `(lsp-capf (styles ,@completion-styles)))
  (add-to-list 'savehist-additional-variables 'corfu-history)
  (require 'corfu-preview)
  ;; (keymap-set corfu-map "RET" `( menu-item "" nil :filter
  ;;                                ,(lambda (&optional _)
  ;;                                   (and (derived-mode-p 'eshell-mode 'comint-mode)
  ;;                                        #'corfu-send))))
  )

;; (require 'corfu-candidate-overlay)
;; (setq corfu-auto t)
;; (corfu-candidate-overla)


(use-package nerd-icons-corfu
  :after corfu
  :init
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter)
  )

(use-package cape
  :init
  (defun corfu-add-cape-dabbrev-h ()
    (add-hook 'completion-at-point-functions #'cape-dabbrev 20 t))
  (defun corfu-add-cape-elisp-block-h ()
    (add-hook 'completion-at-point-functions #'cape-elisp-block 20 t))
  (defun corfu-add-cape-file-h ()
    (add-hook 'completion-at-point-functions #'cape-file 20 t))
  (add-hook 'prog-mode-hook 'corfu-add-cape-file-h)
  (add-hook 'org-mode-hook 'corfu-add-cape-elisp-block-h)
  (add-hook 'markdown-mode-hook 'corfu-add-cape-elisp-block-h)
  (add-hook+ (prog-mode-hook
              text-mode-hook
              conf-mode-hook
              comint-mode-hook
              eshell-mode-hook)
             corfu-add-cape-dabbrev-h)
  :config
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-noninterruptible)
  (advice-add #'lsp-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'comint-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'eglot-completion-at-point :around #'cape-wrap-nonexclusive)
  (advice-add #'pcomplete-completions-at-point :around #'cape-wrap-nonexclusive)
  )

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package auto-yasnippet
  :config
  (general-define-key
   :states '(insert)
   "<backtab>" 'aya-expand
   )
  ;; (define-key (kbd "<backtab>"))
  )

(use-package yasnippet-capf
  :after cape
  :config
  (defun corfu-add-yasnippet-capf-h ()
      (add-hook 'completion-at-point-functions #'yasnippet-capf 10 t))
  (add-hook 'prog-mode-hook 'corfu-add-yasnippet-capf-h)
  )

(provide 'init-corfu)
