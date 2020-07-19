;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-

(load (concat user-emacs-directory "init-packages"))


;; custom file
(setq-default custom-file (concat user-emacs-directory "custom.el"))


(my-load-module 'core)
(my-load-module 'appearance)


;;; init.el ends here
