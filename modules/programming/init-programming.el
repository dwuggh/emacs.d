
(setq load-path 
      (cons (expand-file-name
         (concat straight-base-dir "straight/build/tsc"))
        load-path))

(defun my-url-copy-file (url newname &optional ok-if-already-exists &rest _ignored)
  "See `url-copy-file'."
  (shell-command-to-string (s-concat "graftcp wget " url))
  )

(advice-add 'url-copy-file :override 'my-url-copy-file)

(straight-use-package 'tree-sitter)
(straight-use-package 'tree-sitter-langs)


;; (straight-pull-package "tree-sitter")
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

(use-package citre
  :defer t
  :init
  ;; This is needed in `:init' block for lazy load to work.
  (require 'citre-config)
  ;; Bind your frequently used commands.
  (global-set-key (kbd "C-x c j") 'citre-jump)
  (global-set-key (kbd "C-x c J") 'citre-jump-back)
  (global-set-key (kbd "C-x c p") 'citre-ace-peek)
  :config
  ;; (setq
  ;;  ;; Set this if you use project management plugin like projectile.  It's
  ;;  ;; used for things like displaying paths relatively, see its docstring.
  ;;  citre-project-root-function #'projectile-project-root)
  )

(require 'init-python)
(require 'init-jsts)
;; (require 'init-java)
;; (require 'init-julia)
;; (require 'init-go)

;; (require 'init-cool)
;; (require 'init-asm)

(provide 'init-programming)
