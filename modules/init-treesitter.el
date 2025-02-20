
(use-package treesit
  :ensure nil
  :init
  ;; Major mode remapping
  (setq major-mode-remap-alist
        '((c-mode          . c-ts-mode)
          (c++-mode        . c++-ts-mode)
          (c-or-c++-mode   . c-or-c++-ts-mode)
          (python-mode     . python-ts-mode)
          (go-mode         . go-ts-mode)
          (javascript-mode . js-ts-mode)
          (typescript-mode . typescript-ts-mode)
          (css-mode        . css-ts-mode)
          (json-mode       . json-ts-mode)
          (yaml-mode       . yaml-ts-mode)
          ;; (rust-mode       . rust-ts-mode)
          ;; (rustic-mode     . rust-ts-mode)
          (bash-mode       . bash-ts-mode)
          (sh-mode         . bash-ts-mode)
          (latex-mode      . latex-ts-mode)
          (html-mode       . html-ts-mode)
          (markdown-mode   . markdown-ts-mode)))

  ;; (add-to-list 'auto-mode-alist )

  ;; Font-lock settings
  (setq treesit-font-lock-level 6
        treesit-font-lock-feature-list
        '((comment definition)
          (keyword string type)
          (assignment constant builtin)
          (escape-sequence)))

  ;; Language source configuration
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (latex . ("https://github.com/latex-lsp/tree-sitter-latex"))
          (markdown . ("https://github.com/ikatyang/tree-sitter-markdown"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript"))
          (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))))

  :config
  ;; Enable tree-sitter for all supported modes
  )

;; (use-package treesit-auto
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (setq wgsl-tsauto-config
;;       (make-treesit-auto-recipe
;;        :lang 'wgsl
;;        :ts-mode 'wgsl-ts-mode
;;        :remap 'wgsl-mode
;;        :url "https://github.com/szebniok/tree-sitter-wgsl"
;;        :revision "master"
;;        :source-dir "src"
;;        :ext "\\.wgsl\\'"))

;;   (add-to-list 'treesit-auto-recipe-list wgsl-tsauto-config)
;;   ;; (treesit-auto-add-to-auto-mode-alist 'all)
;;   (global-treesit-auto-mode))
(provide 'init-treesitter)
