

(general-def
  :major-modes 'text-mode
  :states '(normal visual motion)
  "K" 'youdao-dictionary-search-at-point-posframe
  )

(require 'init-spell)
(require 'init-latex)
(require 'init-org)

(use-package beancount-mode
  :ensure (beancount-mode :type git :host github :repo "beancount/beancount-mode"
                          :files ("beancount.el")
                          :main "beancount.el"
                          )
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode)))


(provide 'init-notes)
