;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-

(load (concat user-emacs-directory "init-packages"))


;; custom file
(setq-default custom-file (concat user-emacs-directory "custom.el"))
(add-to-list 'load-path (concat user-emacs-directory "lisp/"))


(my-load-module 'core)
(my-load-module 'appearance)


(my-load-module 'elisp)



(my-load-module 'chinese)

;; (setq load-path (cdr load-path))

;;; init.el ends here
