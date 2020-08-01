
(use-package rust-mode
  :defer t
  :init
  (add-hook 'rust-mode-hook #'lsp)
  )

(use-package cargo
  :defer t
  :init
  (add-hook 'rust-mode-hook 'cargo-minor-mode)
  )

(use-package toml-mode
  :defer t
  ;; from spacemacs
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"
  )

(dwuggh/localleader-def
 :keymaps 'rust-mode-map
 "==" 'rust-format-buffer
 "bs" '(lsp-rust-switch-server :wk "switch backend")

 "c." 'cargo-process-repeat
 "ca" 'cargo-process-add
 "cA" 'cargo-process-audit
 "cc" 'cargo-process-build
 "cC" 'cargo-process-clean
 "cd" 'cargo-process-doc
 "cD" 'cargo-process-doc-open
 "ce" 'cargo-process-bench
 "cE" 'cargo-process-run-example
 "cf" 'cargo-process-fmt
 "ci" 'cargo-process-init
 "cl" 'cargo-process-clippy
 "cn" 'cargo-process-new
 "co" 'cargo-process-current-file-tests
 "cr" 'cargo-process-rm
 "cs" 'cargo-process-search
 "ct" 'cargo-process-current-test
 "cu" 'cargo-process-update
 "cU" 'cargo-process-upgrade
 "cx" 'cargo-process-run
 "cX" 'cargo-process-run-bin
 "cv" 'cargo-process-check
 "cT" 'cargo-process-test
 )
(provide 'init-rust)
