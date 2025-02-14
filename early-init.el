;; (setenv "http_proxy" "socks5://127.0.0.1:1080")
;; (setenv "https_proxy" "socks5://127.0.0.1:1080")
;; (setenv "all_proxy" "socks5://127.0.0.1:1080")

(setenv "COLORTERM" "truecolor")

(setq url-gateway-method 'socks)
(setq socks-server '("Default server" "127.0.0.1" 1080 5))
(setq url-proxy-services
      '(
        ("https" . "127.0.0.1:1080")
        ("http" . "127.0.0.1:1080")
        )
      )

(defvar dwuggh-emacs-type 'full
  "Type of emacs configuration. Can be `full' `terminal' `vps'. Default `full'.")


(setq-default
 custom-file (expand-file-name (concat user-emacs-directory "custom.el"))
 my-cache-dir (concat user-emacs-directory ".cache/")
 ;; gc-cons-threshold 80000000
 )
(setq tramp-persistency-file-name (concat my-cache-dir "tramp"))
(setq find-function-C-source-directory "~/aur/emacs-native-comp-git/src/emacs-git/src")
;; (setq comp-eln-load-path
;;       `(,(concat my-cache-dir "eln-cache") "/usr/bin/../lib/emacs/28.0.50/x86_64-pc-linux-gnu/eln-cache/"))

;; (load (concat user-emacs-directory "init-packages"))
(load-file (concat user-emacs-directory "init-packages.el"))
;; custom file
(add-hook 'elpaca-after-init-hook (lambda () (load custom-file 'noerror)))

(use-package gcmh
  :init
  (setq gcmh-verbose t
        )
  :config
  (gcmh-mode 1)
  )
(elpaca-wait)
