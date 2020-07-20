;; -*- lexical-binding: t; -*-


;; themes
(use-package all-the-icons)
(use-package doom-themes
  :config
  (custom-set-variables
   '(custom-safe-themes
     '("2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" default)))
  (load-theme 'doom-one)
  )



;; fullscreen on start
(add-to-list 'default-frame-alist
             '(fullscreen . maximized))

(defvar dwuggh-font-family
  "Sarasa Term SC"
  "My font family."
  )

(defvar dwuggh-font-size
  12
  "My font size."
  )

(add-to-list 'default-frame-alist
             '(font . "Sarasa Term SC-13"))


;; highlight current line
(global-hl-line-mode t)
(setq-default cursor-type 'box)
(setq-default blink-cursor-mode 0)
(blink-cursor-mode 0)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package doom-modeline
  :init
  (doom-modeline-mode 1))

(use-package page-break-lines
  ;; :config (global-page-break-lines-mode)
  )

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))


(provide 'init-appearance)
