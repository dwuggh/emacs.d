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
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; (use-package all-the-icons)
(use-package doom-themes
  :init
  (setq my-emacs-theme (getenv "EMACS_THEME")
      custom-safe-themes t
      doom-solarized-light-brighter-comments nil
      doom-solarized-light-brighter-modeline nil
      doom-solarized-light-padded-modeline nil
      )
  :config
(cond
 ((equal my-emacs-theme "light") (load-theme 'dwuggh-doom-solarized-light))
 ((equal my-emacs-theme "dark") (load-theme 'doom-one))
 ((equal my-emacs-theme "nord") (load-theme 'doom-nord))
 (t (load-theme 'dwuggh-doom-solarized-light))
 )
  )



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
  :elpaca '(dashboard :no-native-compile t)
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
