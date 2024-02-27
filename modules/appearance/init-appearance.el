;; -*- lexical-binding: t; -*-


;; themes

(defface ivy-current-match
  '((((class color) (background light))
     :background "#1a4b77" :foreground "white" :extend t)
    (((class color) (background dark))
     :background "#65a7e2" :foreground "black" :extend t))
  "Face used by Ivy for highlighting the current match.")

(defface ivy-minibuffer-match-face-1
  '((((class color) (background light))
     :background "#d3d3d3")
    (((class color) (background dark))
     :background "#555555"))
  "The background face for `ivy' minibuffer matches.")

(setq custom-theme-directory (concat user-emacs-directory "modules/appearance/themes/"))
;; disable whatever bar
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(use-package solaire-mode
  :config
  (solaire-global-mode +1)
  )
(use-package vscode-dark-plus-theme)
(use-package doom-themes
  :init
  (setq my-emacs-theme (getenv "EMACS_THEME")
        custom-safe-themes t
        doom-solarized-light-brighter-comments nil
        doom-solarized-light-brighter-modeline nil
        doom-solarized-light-padded-modeline nil
        )
  :config
  ;; (load-theme 'doom-wilmersdorf)
  (load-theme 'doom-one)
  )

(use-package hide-mode-line
  :init
  (add-hook 'completion-list-mode-hook #'hide-mode-line-mode)
  :config
  (setq hide-mode-line-excluded-modes
        (append '(helpful-mode)
                hide-mode-line-excluded-modes)))


;; (auto-hide-mode-line-mode +1)
(use-package auto-hide-mode-line
  :ensure `(auto-hide-mode-line
            :repo ,(concat user-emacs-directory "lisp/auto-hide-mode-line/")
            :files ("auto-hide-mode-line.el")
            )
  :init
  (add-hook 'elpaca-after-init-hook #'auto-hide-mode-line-mode)
  )
;; (require 'auto-hide-mode-line)
;; (auto-hide-mode-line-mode +1)




(defun my--set-transparency (a)
  (set-frame-parameter nil 'alpha-background a))
(defun my-set-transparency ()
  (interactive)
  (my--set-transparency (read-number "alpha channel value:" 90)))

;; fullscreen on start
(my--set-transparency 93)
(toggle-frame-maximized)
(toggle-frame-fullscreen)

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

(use-package default-text-scale
  :config
  (default-text-scale-mode 1))

;; highlight current line
;; (global-hl-line-mode t)
(setq-default cursor-type 'box)
(setq-default blink-cursor-mode 0)
(blink-cursor-mode 0)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package doom-modeline
  :init
  
  (setq nerd-icons-font-family "Symbols Nerd Font Mono")
  (setq
   doom-modeline-enable-word-count t
   nerd-icons-color-icons t
   inhibit-compacting-font-caches nil
   doom-modeline-modal-modern-icon t
   doom-modeline-modal-state-icon t
   )
  (setq doom-modeline-icon t)
  :config
  (doom-modeline-mode 1)
  )

(use-package page-break-lines
  ;; :config (global-page-break-lines-mode)
  )

(use-package dashboard
  :ensure '(dashboard :no-native-compile t)
  :init
  (setq
   ;; dashboard-banner-logo-title "The fire fades..."
   dashboard-banner-logo-title "你好"
;;    dashboard-banner-logo-title "Wherever you go, the moon still sets in Irithyll;
;; Wherever you may be, Irithyll is your home. "
   ;; dashboard-banner-logo-title "Forefathers one and all, bear witness!"
   dashboard-image-extra-props '(:mask heuristic)
   ;; dashboard-startup-banner "~/Pictures/bonfire-transparent.png"
   ;; dashboard-startup-banner "~/Pictures/bonfire-removebg-preview.png"
   ;; dashboard-startup-banner "~/Pictures/bonfire.jpeg"
   ;; dashboard-startup-banner "~/Pictures/bonfire1.jpeg"
   ;; dashboard-startup-banner "~/Pictures/wallpaper/Irithyll.jpg"
   ;; dashboard-startup-banner "~/Pictures/bonfire.gif"
   dashboard-startup-banner (concat user-emacs-directory "icons/エマ.png")
   ;; dashboard-startup-banner "~/Pictures/godrick.png"
   dashboard-image-banner-max-width 800
   dashboard-image-banner-max-width 600
   dashboard-center-content t
   )
  ;; (setq-default
  ;;  dashboard-banners-directory (expand-file-name (concat user-emacs-directory "straight/build/dashboard/banners")))
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook)
  )

(use-package centaur-tabs
  :init
  (setq centaur-tabs-set-icons t
        centaur-tabs-gray-out-icons nil
        centaur-tabs-set-bar 'left
        centaur-tabs-set-modified-marker t
        ;; centaur-tabs-close-button "✕"
        ;; centaur-tabs-modified-marker "•"
        centaur-tabs-modified-marker "⏺"
        centaur-tabs-icon-type 'nerd-icons
        ;; Scrolling (with the mouse wheel) past the end of the tab list
        ;; replaces the tab list with that of another Doom workspace. This
        ;; prevents that.
        centaur-tabs-cycle-scope 'tabs)
  :config
  ;; (remove-hook 'find-file-hook #'centaur-tabs-mode)
  )


;; TODO vscode-like `tab-line-tabs-function'
(use-package tab-line
  :ensure nil

  :config
  (require 'intuitive-tab-line)
  (setq
   tab-line-exclude-modes '(completion-list-mode helpful-mode help-mode)
   tab-line-close-button (propertize " × "
                                     'rear-nonsticky nil ;; important to not break auto-scroll
                                     'keymap tab-line-tab-close-map
                                     'mouse-face 'tab-line-close-highlight
                                     'help-echo "Click to close tab")
   tab-line-switch-cycling t
   tab-line-tab-name-function 'tab-line-buffer-name-with-nerd-icon
   tab-line-tab-name-truncated-max 20
   ;; tab-line-tabs-function 'intuitive-tab-line-buffers-list
   )

  (defun tab-line-buffer-name-with-nerd-icon (buffer &optional _buffers)
    (let* ((buf-name (buffer-name buffer))
           (tab-name (concat (nerd-icons-icon-for-file buf-name) " " buf-name)))
      (if (< (length tab-name) tab-line-tab-name-truncated-max)
          tab-name
        (propertize (truncate-string-to-width
                     tab-name tab-line-tab-name-truncated-max nil nil
                     tab-line-tab-name-ellipsis)
                    'help-echo tab-name))))
  (add-hook 'find-file-hook #'global-tab-line-mode)
  )

(use-package tab-bar
  :ensure nil
  :init
  (setq
   tab-bar-close-button (propertize " × "
                                     'rear-nonsticky nil
                                     'close-tab t
                                     'mouse-face 'tab-line-close-highlight
                                     'help-echo "Click to close tab")
   tab-bar-show nil
   )
  (tab-bar-mode 1)
  
  )



;; (require 'pretty-fonts)
;; (pretty-fonts-add-hook 'prog-mode-hook 'pretty-fonts-fira-code-alist)
;; (pretty-fonts-add-kwds pretty-fonts-fira-code-alist)
(let ((alist `((?! . ,(regexp-opt '("!!" "!=" "!==")))
               (?# . ,(regexp-opt '("##" "###" "####" "#(" "#?" "#[" "#_" "#_(" "#{")))
               (?$ . ,(regexp-opt '("$>")))
               (?% . ,(regexp-opt '("%%")))
               (?& . ,(regexp-opt '("&&")))
               (?* . ,(regexp-opt '("*" "**" "***" "**/" "*/" "*>")))
               (?+ . ,(regexp-opt '("+" "++" "+++" "+>")))
               (?- . ,(regexp-opt '("--" "---" "-->" "-<" "-<<" "->" "->>" "-}" "-~")))
               (?. . ,(regexp-opt '(".-" ".." "..." "..<" ".=")))
               (?/ . ,(regexp-opt '("/*" "/**" "//" "///" "/=" "/==" "/>")))
               (?: . ,(regexp-opt '(":" "::" ":::" ":=")))
               (?\; . ,(regexp-opt '(";;")))
               (?< . ,(regexp-opt '("<!--" "<$" "<$>" "<*" "<*>" "<+" "<+>" "<-" "<--" "<->" "</" "</>" "<<" "<<-" "<<<" "<<=" "<=" "<=" "<=<" "<==" "<=>" "<>" "<|" "<|>" "<~" "<~~")))
               (?= . ,(regexp-opt '("=/=" "=:=" "=<<" "==" "===" "==>" "=>" "=>>")))
               (?> . ,(regexp-opt '(">-" ">=" ">=>" ">>" ">>-" ">>=" ">>>")))
               (?= . ,(regexp-opt '("?=")))
               (?? . ,(regexp-opt '("??")))
               (?\[ . ,(regexp-opt '("[]")))
               (?\\ . ,(regexp-opt '("\\\\" "\\\\\\")))
               (?^ . ,(regexp-opt '("^=")))
               (?w . ,(regexp-opt '("www")))
               ;; (?x . ,(regexp-opt '("x")))
               (?{ . ,(regexp-opt '("{-")))
               (?| . ,(regexp-opt '("|=" "|>" "||" "||=")))
               (?~ . ,(regexp-opt '("~-" "~=" "~>" "~@" "~~" "~~>"))))))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

(provide 'init-appearance)
