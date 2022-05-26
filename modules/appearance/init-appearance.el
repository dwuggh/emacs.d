;; -*- lexical-binding: t; -*-


;; themes
(use-package all-the-icons)
(setq custom-theme-directory (concat user-emacs-directory "modules/appearance/themes/"))
(use-package doom-themes)

(use-package base16-theme
  :config
  (defvar my/base16-colors base16-default-dark-colors)
  (setq evil-emacs-state-cursor   `(,(plist-get my/base16-colors :base0D) box)
        evil-insert-state-cursor  `(,(plist-get my/base16-colors :base0D) bar)
        evil-motion-state-cursor  `(,(plist-get my/base16-colors :base0E) box)
        evil-normal-state-cursor  `(,(plist-get my/base16-colors :base0B) box)
        evil-replace-state-cursor `(,(plist-get my/base16-colors :base08) bar)
        evil-visual-state-cursor  `(,(plist-get my/base16-colors :base09) box))
  )

;; (use-package spacemacs-theme)

(setq my-emacs-theme (getenv "EMACS_THEME")
      custom-safe-themes t
      doom-solarized-light-brighter-comments nil
      doom-solarized-light-brighter-modeline nil
      doom-solarized-light-padded-modeline nil
      )
(cond
 ((equal my-emacs-theme "light") (load-theme 'dwuggh-doom-solarized-light))
 ((equal my-emacs-theme "dark") (load-theme 'doom-one))
 ((equal my-emacs-theme "nord") (load-theme 'doom-nord))
 (t (load-theme 'dwuggh-doom-solarized-light))
 )

;; disable whatever bar
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)


;; fullscreen on start
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
(global-hl-line-mode t)
(setq-default cursor-type 'box)
(setq-default blink-cursor-mode 0)
(blink-cursor-mode 0)

(fset 'yes-or-no-p 'y-or-n-p)

(use-package doom-modeline
  :init
  (setq doom-modeline-enable-word-count t)
  ;; (setq global-mode-string
  ;;     '(:eval (format "%d chars" (- (line-end-position) (line-beginning-position)))))
  :config
  (display-battery-mode 1)
  (doom-modeline-mode 1)
  )

(use-package page-break-lines
  ;; :config (global-page-break-lines-mode)
  )

(straight-use-package '(dashboard
              :no-native-compile t))
(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "Dare Evil"
    dashboard-startup-banner 2
    dashboard-center-content t
    )
  ;; (setq-default
  ;;  dashboard-banners-directory (expand-file-name (concat user-emacs-directory "straight/build/dashboard/banners")))
  :config
  (dashboard-setup-startup-hook)
  )

(use-package centaur-tabs
  :defer t
  :config
  (centaur-tabs-mode t)
  (dwuggh/leader-def
    "a" '(:ignore t :wk "tab")
    "ah" 'centaur-tabs-backward
    "al" 'centaur-tabs-forward
    )
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
