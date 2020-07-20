;;; init-packages.el --- init all packages using melpa and straight -*- lexical-binding: t; -*-

;; init straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq straight-use-package-by-default t)

(straight-use-package 'use-package)

(defconst my-module-path (concat user-emacs-directory "modules/")
  "My module path. Could contain .el file or sub directory.")

(add-to-list 'load-path my-module-path)

(defun my-load-module (module)
  "load module"
  (let* (
        (name (symbol-name module))
        (init-name (concat "init-" name)))
    (if (file-exists-p (concat my-module-path init-name ".el"))
        (require (intern init-name))
      (add-to-list 'load-path (concat my-module-path name "/"))
      (require (intern init-name))
      ;; (let ((load-path (cons (concat dir name "/") load-path)))
      ;;   (require (intern init-name)))
      )))



(provide 'init-packages)
;;; init-packages.el ends here
