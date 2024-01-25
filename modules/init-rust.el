
(use-package rustic
  :defer t
  :init
  ;; (setq rustic-lsp-setup-p nil)
  (defun rust-rustup-target-list ()
    "Get rustup's target list using `rustup target list'."
    (s-split "\n" (s-trim (shell-command-to-string "rustup target list")))
    )

  (defun rust-rustup-target-list-installed ()
    "Get installed rustup's target list using `rustup target list --installed'."
    (s-split "\n" (s-trim (shell-command-to-string "rustup target list --installed")))
    )

  (defun lsp-rust-analyzer--select-cargo-target (new-target)
    (when (s-ends-with? "(installed)" new-target)
      (setq new-target (car (s-split " " new-target))))
    (unless (equal new-target lsp-rust-analyzer-cargo-target)
      (setq lsp-rust-analyzer-cargo-target new-target)
      (if (y-or-n-p "restart workspace?")
          (call-interactively 'lsp-workspace-restart))))

  (defun lsp-rust-analyzer-select-cargo-target ()
    "Interactively select `lsp-rust-analyzer-cargo-target'.
This requires rustup intsalled"
    (interactive)
    (lsp-rust-analyzer--select-cargo-target
     (completing-read "set cargo target: " (rust-rustup-target-list-installed) nil t)))
  )


(use-package toml-mode
  :defer t
  ;; from spacemacs
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"
  :init
  (add-hook 'toml-mode-hook #'smartparens-mode)
  )

(use-package wgsl-mode
  :elpaca
  (wgsl-mode :type git :host github :repo "acowley/wgsl-mode")
  )
(use-package glsl-mode
  :elpaca
  (glsl-mode :type git :host github :repo "jimhourihan/glsl-mode")
  )


(dwuggh/localleader-def
 :keymaps 'rustic-mode-map
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
