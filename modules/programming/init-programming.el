
(setq load-path 
      (cons (expand-file-name
         (concat straight-base-dir "straight/build/tsc"))
        load-path))

(defun my-url-copy-file (url newname &optional ok-if-already-exists &rest _ignored)
  "See `url-copy-file'."
  ;; TODO
  )

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)


(use-package tree-sitter-langs)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(global-tree-sitter-mode)

(setq-default tab-width 4)

(defun my-run-make ()
  "run make in current dir"
  (interactive)
  (async-shell-command "make" "*my-run-make-log*" "*my-run-make-error*")
)

(setq display-buffer-alist
      (cons '("\\*my-run-make-*" display-buffer-no-window)
        display-buffer-alist))

(use-package separedit
  :config
  (define-key prog-mode-map        (kbd "C-c '") #'separedit)
  (define-key minibuffer-local-map (kbd "C-c '") #'separedit)
  (define-key help-mode-map        (kbd "C-c '") #'separedit)
  (define-key helpful-mode-map     (kbd "C-c '") #'separedit)
  (setq separedit-default-mode 'markdown-mode)
  )

(require 'init-python)
(require 'init-java)
(require 'init-jsts)
(require 'init-julia)
(require 'init-go)

(require 'init-cool)

(provide 'init-programming)
