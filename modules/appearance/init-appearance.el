;; -*- lexical-binding: t; -*-


;; themes
(use-package doom-themes
  :config
  (load-theme 'doom-one))

;; fullscreen on start
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(provide 'init-appearance)
