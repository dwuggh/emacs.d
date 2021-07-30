
(defun my-completion-in-region-function ()
  (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args))
  )

(general-define-key
 :states '(normal visual)
 :keymaps 'override
 "C-h A" 'describe-face
 )

(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-count 17
        vertico-cycle t
        )
  ;; https://emacs.stackexchange.com/questions/14755/how-to-remove-bindings-to-the-esc-prefix-key
  (define-key key-translation-map (kbd "ESC") (kbd "C-g"))
  :config
  ;; (define-key vertico-map "?" #'minibuffer-completion-help)
  (define-key vertico-map (kbd "M-RET") #'minibuffer-force-complete-and-exit)
  (define-key vertico-map (kbd "M-TAB") #'minibuffer-complete)
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous)
  (custom-set-faces
   '(completions-common-part
      (( t :inherit ivy-minibuffer-match-face-1 )))
   '(vertico-current
      (( t :inherit ivy-prompt-match )))
   '(marginalia-documentation
      (( t :inherit font-lock-doc-face )))
   '(orderless-match-face-0
      (( t :inherit ivy-minibuffer-match-face-1 )))
   '(orderless-match-face-1
      (( t :inherit ivy-minibuffer-match-face-2 )))
   '(orderless-match-face-2
      (( t :inherit ivy-minibuffer-match-face-3 )))
   '(orderless-match-face-3
      (( t :inherit ivy-minibuffer-match-face-4 )))
   )
  ;; (setq minibuffer-prompt-properties
  ;;       '(read-only t cursor-intangible t face minibuffer-prompt))
  ;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
  )
(use-package embark
  (define-key vertico-map (kbd "C-\"") 'embark-act)
  (define-key vertico-map (kbd "C-/") 'embark-dwim)
  
  )
(use-package consult
  :init
  (setq consult-async-min-input 2
        consult-async-refresh-delay 0.1
        consult-async-split-style 'space
        consult-async-input-throttle 0.1
        consult-async-input-debounce 0.1
        completion-in-region-function #'consult-completion-in-region
        )
  :config
  )
(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  )

(use-package marginalia
  :init
  (marginalia-mode)
  )

(use-package orderless
  :init
  (setq completion-styles '(substring orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))


(provide 'init-vertico)
