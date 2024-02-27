
(use-package treesit
  :ensure nil
  :init
  (setq major-mode-remap-alist
        '(
          (c-mode . c-ts-mode)
          (c++-mode . c++-ts-mode)
          (c-or-c++-mode . c-or-c++-ts-mode)
          (python-mode . python-ts-mode)
          (go-mode . go-ts-mode)
          )
        )
  (setq treesit-font-lock-level 4)
  ;; TODO bettter way
  ;; (setq treesit-language-source-alist
  ;;     '((python . ( "https://github.com/tree-sitter/tree-sitter-python.git" ))
  ;;       (c . ("https://github.com/tree-sitter/tree-sitter-c.git"))
  ;;       (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp.git"))
  ;;       (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript.git"))
  ;;       (rust . ("https://github.com/tree-sitter/tree-sitter-rust.git"))
  ;;       (haskell . ("https://github.com/tree-sitter/tree-sitter-haskell.git"))
  ;;       (go . ("https://github.com/tree-sitter/tree-sitter-go.git"))
  ;;       (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript.git"))
  ;;       (latex . ("https://github.com/latex-lsp/tree-sitter-latex.git"))
  ;;       )
  ;;     )
  ;; :config
  )

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)
  :config
  (setq wgsl-tsauto-config
      (make-treesit-auto-recipe
       :lang 'wgsl
       :ts-mode 'wgsl-ts-mode
       :remap 'wgsl-mode
       :url "https://github.com/szebniok/tree-sitter-wgsl"
       :revision "master"
       :source-dir "src"
       :ext "\\.wgsl\\'"))

  (add-to-list 'treesit-auto-recipe-list wgsl-tsauto-config)
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
(provide 'init-treesitter)
