
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
   company-tooltip-align-annotations t
   ;; fuck, why this could even change???
   company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
                       company-echo-metadata-frontend
                       company-preview-if-just-one-frontend)
   company-selection-default 0
   company-dabbrev-downcase nil
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

(use-package company-prescient
  :config
  (company-prescient-mode 1))

(use-package company-quickhelp
  :config
  (company-quickhelp-mode))


(use-package yasnippet
  :config
  (yas-global-mode 1)
  
  (defun my-company-yasnippet-disable-inline (fn cmd &optional arg &rest _ignore)
    "Enable yasnippet but disable it inline."
    (if (eq cmd  'prefix)
        (when-let ((prefix (funcall fn 'prefix)))
          (unless (memq (char-before (- (point) (length prefix)))
                        '(?. ?< ?> ?\( ?\) ?\[ ?{ ?} ?\" ?' ?`))
            prefix))
      (progn
        (when (and (bound-and-true-p lsp-mode)
                   arg (not (get-text-property 0 'yas-annotation-patch arg)))
          (let* ((name (get-text-property 0 'yas-annotation arg))
                 (snip (format "%s (Snippet)" name))
                 (len (length arg)))
            (put-text-property 0 len 'yas-annotation snip arg)
            (put-text-property 0 len 'yas-annotation-patch t arg)))
        (funcall fn cmd  arg))))
  ;; (advice-add #'company-yasnippet :around #'my-company-yasnippet-disable-inline)
  )

(use-package auto-yasnippet
  :config
  (general-define-key
   :states '(insert)
   "<backtab>" 'aya-expand
   )
  ;; (define-key (kbd "<backtab>"))
  )

;; (use-package yasnippet-snippets)

(use-package company-box
  :elpaca '(company-box
              :no-native-compile t)
  :hook (company-mode . company-box-mode)
  :init
  (setq company-box-backends-colors
    '((company-yasnippet :all "light blue" :selected
                 (:background :foreground "black"))))
  (setq company-box-doc-delay 0.2
        company-box-icons-alist 'company-box-icons-images
        )
  )


;; backend
(setq-default company-backends
              '(
                (:separate company-capf company-yasnippet)
        (company-dabbrev company-dabbrev-code)
        ))


(provide 'init-company)
