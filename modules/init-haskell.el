
(use-package haskell-mode
  :defer t
  :config
  (defun haskell-compile-and-run ()
    "Compile and run current .hs file."
    (interactive)
    (haskell-compile "")
    )
  )

(use-package lsp-haskell
  :defer t
  :init
  (add-hook 'haskell-mode-hook #'my-lsp-init)
  (add-hook 'haskell-mode-hook #'dante-mode)
  (add-hook 'haskell-literate-mode-hook #'my-lsp-init)
  ;; (setq lsp-haskell-process-path-hie "haskell-language-server-8.10.2")
  ;; (setq lsp-haskell-process-args-hie nil)
  ;; (setq lsp-haskell-server-path "/home/dwuggh/.ghcup/bin/haskell-language-server-wrapper")
  ;; (setq lsp-haskell-server-path "/home/dwuggh/.local/bin/ghcide")
  :config
  (setq haskell-process-auto-import-loaded-modules t
        haskell-process-show-overlays nil
        )
  ;; (lsp-haskell-set-hlint-on)
  ;; (lsp-haskell-set-completion-snippets-on)
  )

;; (straight-register-package
;;  `(ghc :type git :host github
;;        :repo "emacsattic/ghc" :files ("elisp/*.el")))
;; (use-package company-ghc)

;; (use-package dante
;;   :after haskell
;;   :init
;;   (setq dante-load-flags
;;         '(;; defaults:
;;           "+c"
;;           "-Wwarn=missing-home-modules"
;;           "-fno-diagnostics-show-caret"
;;           ;; necessary to make attrap-attrap useful:
;;           "-Wall"
;;           ;; necessary to make company completion useful:
;;           "-fdefer-typed-holes"
;;           "-fdefer-type-errors")
;;         )
;;   (setq-mode-local haskell-mode
;;                    company-backends
;;                    '((company-capf dante-company :with company-yasnippet)
;;                      company-dabbrev
;;                      company-capf
;;                      )
;;                    )
;;   :config
;;   (dwuggh/localleader-def
;;     :keymaps 'dante-mode-map
;;     "t" 'dante-type-at
;;     "d" 'dante-doc
;;     )
;;   )
;; (use-package attrap)

(use-package yaml-mode
  :defer t)

(provide 'init-haskell)
