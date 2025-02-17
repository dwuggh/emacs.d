(defvar my-C-f-funcs '())
(defun my-C-f ()
  (interactive)
  (unless (call-interactively 'tabby-accept-completion)
    (forward-char)))

(use-package tabby
  :hook (prog-mode . tabby-mode)
  :ensure (tabby :type git :host github :files ("*.el" "node_scripts")
                 :repo "alan-w-255/tabby.el")
  :init
  (setq tabby-idle-delay 0.5)
  :config
  (add-to-list 'my-C-f-funcs 'tabby-accept-completion)
  ;; (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'tabby-accept-completion)
  ;; (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'my-C-f)
  (evil-define-key 'insert tabby-mode-map (kbd "C-f") 'my-C-f)

  (evil-define-key 'insert tabby-mode-map (kbd "C-M-j") 'tabby-dismiss)

  (evil-define-key 'insert tabby-mode-map (kbd "C-M-l") 'tabby-accept-completion-by-line)
  )

(use-package tabnine
  :commands (tabnine-start-process)
  ;; :hook (prog-mode . tabnine-mode)
  :diminish "⌬"
  :custom
  (tabnine-wait 1)
  (tabnine-minimum-prefix-length 0)
  :hook (kill-emacs . tabnine-kill-process)
  :config
  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
  (setq tabnine-log-file-path (concat my-cache-dir "tabnine-log"))
  )

(provide 'init-ai)
