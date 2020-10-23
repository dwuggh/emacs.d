
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
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(straight-use-package '(company-box
		      :no-native-compile t))
(use-package company-box
  :hook (company-mode . company-box-mode)
  :init
  (setq company-box-backends-colors
	'((company-yasnippet :all "light blue" :selected
			     (:background :foreground "black"))))
  (setq company-box-doc-delay 0.2)
  )


;; Debugger entered--Lisp error: (error "Invalid byte opcode: op=0, ptr=6")
;;   company-box--scrollbar-prevent-changes()
;;   redisplay_internal\ \(C\ function\)()
(use-package company-posframe
  :config
  (setq company-posframe-quickhelp-delay 0.2)
  ;; (company-posframe-mode 1)
  ;; (general-define-key company-posframe-active-map
  ;; 		      :states 'insert
  ;; 		      "C-f" 'company-posframe-quickhelp-toggle
  ;; 		      "C-n" 'company-posframe-quickhelp-scroll-up
  ;; 		      "C-p" 'company-posframe-quickhelp-scroll-down
  ;; 		      )
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-f") 'company-posframe-quickhelp-toggle)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-f") 'company-show-doc-buffer)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-n") 'company-posframe-quickhelp-scroll-down)
  ;; (evil-define-key 'insert company-posframe-active-map (kbd "C-p") 'company-posframe-quickhelp-scroll-up)
  )


;; backend
(setq-default company-backends
	      '((company-capf company-dabbrev-code :with company-yasnippet)
		(company-dabbrev :with company-yasnippet)
		company-yasnippet))


(provide 'init-company)
