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

(defun my-load-module (module)
  ;; (setq load-path
  ;;       (cons (concat
  ;;              user-emacs-directory
  ;;              (symbol-name module))
  ;;             load-path))
  ;; (load (concat "init-" (symbol-name module)))
  (load (concat user-emacs-directory "modules/" (symbol-name module)
                "/init-" (symbol-name module)))
  )



(provide 'init-packages)
;;; init-packages.el ends here
