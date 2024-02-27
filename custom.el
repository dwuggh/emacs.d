


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(safe-local-variable-values
   '((lsp-rust-analyzer-cargo-target . "aarch64-linux-android")
     (lsp-rust-analyzer-cargo-target "aarch64-linux-android")))
 '(warning-suppress-log-types
   '(((elpaca-use-package-compat)) ((elpaca-use-package-compat))
     ((elpaca-use-package-compat))))
 '(warning-suppress-types
   '(((elpaca-use-package-compat)) (comp) (use-package) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blamer-face ((t :foreground "#7a88cf" :background nil :height 140 :italic t)) t)
 '(completions-common-part ((t :inherit ivy-minibuffer-match-face-1)))
 '(tab-line-tab ((t :height 1.0)))
 '(tab-line-tab-current ((t :background nil :foreground nil :weight normal :inherit font-lock-escape-face)))
 '(tab-line-tab-modified ((t :background nil :foreground nil :slant italic :inherit font-lock-warning-face)))
 '(vertico-current ((t :inherit ivy-prompt-match))))
