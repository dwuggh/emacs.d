;; (use-package codeium
;;     ;; if you use straight
;;     :elpaca (codeium :host github :repo "Exafunction/codeium.el")
;;     ;; otherwise, make sure that the codeium.el file is on load-path

;;     :init
;;     ;; use globally
;;     ;; (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)
;;     ;; or on a hook
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions '(codeium-completion-at-point))))

;;     ;; if you want multiple completion backends, use cape (https://github.com/minad/cape):
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local completion-at-point-functions
;;     ;;             (list (cape-super-capf #'codeium-completion-at-point #'lsp-completion-at-point)))))
;;     ;; an async company-backend is coming soon!

;;     ;; codeium-completion-at-point is autoloaded, but you can
;;     ;; optionally set a timer, which might speed up things as the
;;     ;; codeium local language server takes ~0.2s to start up
;;     ;; (add-hook 'emacs-startup-hook
;;     ;;  (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;;     ;; :defer t ;; lazy loading, if you want
;;     :config
;;     (setq use-dialog-box nil) ;; do not use popup boxes

;;     ;; if you don't want to use customize to save the api-key
;;     ;; (setq codeium/metadata/api_key "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx")

;;     ;; get codeium status in the modeline
;;     (setq codeium-mode-line-enable
;;         (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
;;     (add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)
;;     ;; alternatively for a more extensive mode-line
;;     ;; (add-to-list 'mode-line-format '(-50 "" codeium-mode-line) t)

;;     ;; use M-x codeium-diagnose to see apis/fields that would be sent to the local language server
;;     ;; (setq codeium-api-enabled
;;     ;;     (lambda (api)
;;     ;;         (memq api '(GetCompletions Heartbeat CancelRequest GetAuthToken RegisterUser auth-redirect AcceptCompletion))))
;;     ;; you can also set a config for a single buffer like this:
;;     ;; (add-hook 'python-mode-hook
;;     ;;     (lambda ()
;;     ;;         (setq-local codeium/editor_options/tab_size 4)))

;;     ;; You can overwrite all the codeium configs!
;;     ;; for example, we recommend limiting the string sent to codeium for better performance
;;     (defun my-codeium/document/text ()
;;         (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (min (+ (point) 1000) (point-max))))
;;     ;; if you change the text, you should also change the cursor_offset
;;     ;; warning: this is measured by UTF-8 encoded bytes
;;     (defun my-codeium/document/cursor_offset ()
;;         (codeium-utf8-byte-length
;;             (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
;;     (setq codeium/document/text 'my-codeium/document/text)
;;     (setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)
;;     )

(defvar my-C-f-funcs '())
(defun my-C-f ()
  (interactive)
  (unless (call-interactively 'tabby-accept-completion)
    (forward-char)))

(use-package tabby
  :hook (prog-mode . tabby-mode)
  :elpaca (tabby :type git :host github :files ("*.el" "node_scripts")
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
  ;; (tabnine-start-process)
  ;; :bind
  ;; (:map  tabnine-completion-map
  ;;        ("<tab>" . tabnine-accept-completion)
  ;;        ("TAB" . tabnine-accept-completion)
  ;;        ("M-f" . tabnine-accept-completion-by-word)
  ;;        ("M-<return>" . tabnine-accept-completion-by-line)
  ;;        ("C-g" . tabnine-clear-overlay)
  ;;        ("M-[" . tabnine-previous-completion)
  ;;        ("M-]" . tabnine-next-completion))
  )

(provide 'init-ai)
