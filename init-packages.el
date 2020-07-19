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

(add-to-list 'load-path (concat user-emacs-directory "modules/"))

(defun my-load-module (module)
  "load module"
  (let* ((dir (concat user-emacs-directory "modules/"))
        (name (symbol-name module))
        (init-name (concat "init-" name)))
    (unless (file-exists-p (concat dir init-name ".el"))
      (add-to-list 'load-path (concat dir name "/")))
    (require (intern init-name)))
  )



(provide 'init-packages)
;;; init-packages.el ends here
