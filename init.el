;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-

(load (concat user-emacs-directory "init-packages"))


;; custom file
(setq-default custom-file (concat user-emacs-directory "custom.el"))


(my-load-module 'appearance)
(my-load-module 'evil)
(my-load-module 'search)


;;; init.el ends here
