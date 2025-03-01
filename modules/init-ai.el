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

(use-package gptel)
(use-package ellama)

;; (require 'lsp)
(with-eval-after-load 'lsp-mode
  (lsp-register-client
    (make-lsp-client  :new-connection (lsp-stdio-connection '("npx" "tabby-agent" "--stdio"))
                      ;; you can select languages to enable Tabby language server
                      :activation-fn (lsp-activate-on "typescript" "javascript" "toml" "rust" "emacs-lisp")
                      :priority 1
                      :add-on? t
                      :server-id 'tabby-agent))
  )


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
