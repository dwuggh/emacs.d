;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-

(load (concat user-emacs-directory "init-packages"))


;; custom file
(setq-default custom-file (concat user-emacs-directory "custom.el")
	      my-cache-dir (concat user-emacs-directory ".cache/"))

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; (require 'org-paste-image)


(my-load-module 'editor)
(my-load-module 'search)
(my-load-module 'git)
(my-load-module 'appearance)

(my-load-module 'lsp)
(my-load-module 'treemacs)


(my-load-module 'elisp)

(my-load-module 'chinese)
(my-load-module 'notes)

;; programming languages
(my-load-module 'haskell)
(my-load-module 'rust)
(my-load-module 'cc)
(my-load-module 'programming)

;; (setq load-path (cdr load-path))

;;; init.el ends here
