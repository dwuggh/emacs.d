;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-

;; (setenv "http_proxy" "socks5://127.0.0.1:1080")
;; (setenv "https_proxy" "socks5://127.0.0.1:1080")
;; (setenv "all_proxy" "socks5://127.0.0.1:1080")
(setq-default
 custom-file (concat user-emacs-directory "custom.el")
 my-cache-dir (concat user-emacs-directory ".cache/")
 gc-cons-threshold 80000000
 )

(load-file custom-file)

(setq comp-eln-load-path
      `(,(concat my-cache-dir "eln-cache") "/usr/bin/../lib/emacs/28.0.50/x86_64-pc-linux-gnu/eln-cache/"))

(load (concat user-emacs-directory "init-packages"))


;; custom file

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; (require 'org-paste-image)


(my-load-module 'editor)
(my-load-module 'search)
(my-load-module 'git)
(my-load-module 'appearance)

(my-load-module 'term)

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


(my-load-module 'eaf)

;; (setq load-path (cdr load-path))

;;; init.el ends here
