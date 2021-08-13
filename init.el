;;; init.el --- personal emacs config init file -*- lexical-binding: t; -*-




(load-file custom-file)



;; custom file

(add-to-list 'load-path (concat user-emacs-directory "lisp/"))

;; (require 'org-paste-image)


(my-load-module 'editor)
(my-load-module 'search)
(my-load-module 'git)
(my-load-module 'appearance)

(when (eq dwuggh-emacs-type 'full)
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
    )



;; (my-load-module 'eaf)

;; (setq load-path (cdr load-path))

;;; init.el ends here
