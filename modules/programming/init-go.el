

(use-package go-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
  (add-hook 'go-mode-hook 'lsp-deferred)
  :config
  (push (cons go-test-buffer-name '(:dedicated t :position bottom :stick t :noselect t :height 0.4)) popwin:special-display-config)
  )

(use-package go-impl
  :defer t
  :init
  (dwuggh/localleader-def
   :keymaps 'go-mode-map
   "f<" 'go-guru-callers
   "f>" 'go-guru-callees
   "fc" 'go-guru-peers
   "fd" 'go-guru-describe
   "fe" 'go-guru-whicherrs
   "ff" 'go-guru-freevars
   "fi" 'go-guru-implements
   "fj" 'go-guru-definition
   "fo" 'go-guru-set-scope
   "fp" 'go-guru-pointsto
   "fr" 'go-guru-referrers
   "fs" 'go-guru-callstack

   "=g"  'gofmt
   "eb" 'go-play-buffer
   "ed" 'go-download-play
   "er" 'go-play-region
   "ga" 'ff-find-other-file
   "gc" 'go-coverage
   "hh" 'godoc-at-point
   "ia" 'go-import-add
   "ig" 'go-goto-imports

   "ri" 'go-impl
   )
  )

(provide 'init-go)
