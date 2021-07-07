
(use-package cool-mode
  :defer t
  :straight
  (cool-mode :type git :host github
         :repo "markxnelson/cool-mode")
  :config
  (setq auto-mode-alist
    (append '(("\\.cl\\'" . cool-mode)) auto-mode-alist)))

(provide 'init-cool)
