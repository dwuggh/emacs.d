
(use-package rust-mode
  :init
  (setq rust-mode-treesitter-derive t)
  (setq lsp-rust-analyzer-max-inlay-hint-length 30)
  
  )



;;   )

(defun rust-cargo-fmt ()
  "run cargo fmt"
  (interactive)
  (s-split "\n" (s-trim (shell-command-to-string "rustup target list"))))

(defun rust-cargo-fmt ()
  "Run `cargo fmt` on the current buffer using the project root."
  (interactive)
  ;; (require 'project) ; Ensure the `project` package is loaded
  (let* ((file (buffer-file-name))
         (project-root (project-root (project-current nil file)))
         (default-directory (or project-root default-directory)))
    (if (not (executable-find "cargo"))
        (error "`cargo` not found in PATH")
      (with-temp-message "Running `cargo fmt`..."
        (if (zerop (call-process "cargo" nil nil nil "fmt" "--" file))
            (progn
              (revert-buffer t t t) ; Reload the buffer to reflect changes
              (message "`cargo fmt` completed successfully"))
          (error "`cargo fmt` failed"))))))

(defun my-cargo-test-at-point ()
  "Run `cargo test` for the test function under the cursor."
  (interactive)
  (require 'project) ; Ensure the `project` package is loaded
  (let* ((file (buffer-file-name))
         (project-root (project-root (project-current nil file)))
         (default-directory (or project-root default-directory))
         (test-name (rustic-test-name-at-point)))
    (if (not (executable-find "cargo"))
        (error "`cargo` not found in PATH")
      (if (not test-name)
          (error "No test function found at point")
        (with-temp-message (format "Running `cargo test` for %s..." test-name)
          (compile (format "cargo test %s" test-name)))))))

(defun rustic-test-name-at-point ()
  "Get the name of the test function at the cursor position."
  (save-excursion
    (beginning-of-line)
    (when (re-search-forward "fn \\(test_[^ ]+\\)()" (line-end-position) t)
      (match-string 1))))

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

(use-package toml-mode
  :defer t
  ;; from spacemacs
  :mode "/\\(Cargo.lock\\|\\.cargo/config\\)\\'"
  :init
  (add-hook 'toml-mode-hook #'smartparens-mode)
  )

(use-package wgsl-mode
  :ensure
  (wgsl-mode :type git :host github :repo "acowley/wgsl-mode")
  )
(use-package wgsl-ts-mode
  :ensure
  (wgsl-ts-mode :type git :host github :repo "acowley/wgsl-ts-mode")
  )
(use-package glsl-mode
  :ensure
  (glsl-mode :type git :host github :repo "jimhourihan/glsl-mode")
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
