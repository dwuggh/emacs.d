;; (defvar my-C-f-funcs '())
;; (defun my-C-f ()
;;   (interactive)
;;   (unless (call-interactively 'tabby-accept-completion)
;;     (forward-char)))

;; (use-package tabby
;;   :hook (prog-mode . tabby-mode)
;;   :ensure (tabby :type git :host github :files ("*.el" "node_scripts")
;;                  :repo "alan-w-255/tabby.el")
;;   :init
;;   (setq tabby-idle-delay 0.5)
;;   :config
;;   (add-to-list 'my-C-f-funcs 'tabby-accept-completion)
;;   ;; (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'tabby-accept-completion)
;;   ;; (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'my-C-f)
;;   (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'my-C-f)

;;   (evil-define-key 'insert tabby-mode-map (kbd "C-M-j") 'tabby-dismiss)

;;   (evil-define-key 'insert tabby-mode-map (kbd "C-M-l") 'tabby-accept-completion-by-line)
;;   )

(use-package aider
  :ensure (aider :type git :host github :files ("aider.el" "aider-etc.el")
                 :repo "tninja/aider.el")
  :config
  (add-to-list 'exec-path "~/.local/bin/")
  (setq aider-args '())
  (dwuggh/leader-def
    "aa" 'aider-transient-menu)
  )

(provide 'init-ai)
