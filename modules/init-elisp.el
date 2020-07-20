;;; -*- lexical-binding: t; -*-

(require 'lib-hack)

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode)
  )

(dwuggh/localleader-def
 :major-modes 'emacs-lisp-mode
 "hh" '(helpful-at-point :wk "help at point")
 "'" '(ielm :wk "open ielm")
 )


;; TODO use the macro
;; (setq-modes-local (emacs-lisp-mode lisp-interaction-mode)
;;                  company-backends
;;                  '((company-elisp company-dabbrev-code :with company-yasnippet)
;;                    (company-capf company-dabbrev)))


(setq-mode-local lisp-interaction-mode
                  company-backends
                  '((company-capf company-dabbrev-code :with company-yasnippet company-elisp)
                    (company-capf company-dabbrev)))

(setq-mode-local emacs-lisp-mode
                  company-backends
                  '((company-capf company-dabbrev-code :with company-yasnippet company-elisp)
                    company-dabbrev))


(provide 'init-elisp)
