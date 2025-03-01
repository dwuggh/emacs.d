;;; -*- lexical-binding: t; -*-

(use-package posframe-plus
  :ensure nil
  :load-path "~/Projects/posframe-plus/"
  )

(use-package lsp-proxy
  :ensure nil
  :load-path "~/Projects/lsp-proxy/"
  :hook
  (rust-mode . lsp-proxy-mode)
  (typescript-ts-mode . lsp-proxy-mode)
  :init
  ;; (add-hook 'tsx-ts-mode-hook #'lsp-proxy-mode)
  ;; (add-hook 'js-ts-mode-hook #'lsp-proxy-mode)
  (setq lsp-proxy-log-level 3
        lsp-proxy-max-completion-item 40
        )
  (setq lsp-proxy-inline-completion-disable-predicates
        '(lsp-proxy--inline-completion-overlay-avaible))
  ;; (add-hook 'lsp-proxy-mode-hook 'lsp-proxy-inlay-hints-mode)
  :config
  (require 'posframe-plus)
  (defun lsp-proxy-hover-at-point ()
    "Display the type signature and documentation of the thing at point."
    (interactive)
    (lsp-proxy--async-request
     'textDocument/hover
     (lsp-proxy--request-or-notify-params (lsp-proxy--TextDocumentPosition))
     :success-fn (lambda (hover-help)
                   (if (and hover-help (not (equal hover-help "")))
                       (let ((height 1))
                         (with-current-buffer (get-buffer-create lsp-proxy-hover-buffer)
                           (read-only-mode -1)
                           (let ((delay-mode-hooks t))
                             (erase-buffer)
                             (insert (lsp-proxy--format-markup hover-help))
                             (gfm-view-mode)
                             (let ((lines (line-number-at-pos)))
                               (if (> lines height)
                                   (setq height (min lines 30)))))
                           (run-mode-hooks))
                         (posframe-plus-show lsp-proxy-hover-buffer t t
                                             :position (point)
                                             :timeout 30
                                             :internal-border-color "orange"
                                             :internal-border-width 1
                                             ;; :background-color background-color
                                             :accept-focus nil
                                             :width 100
                                             :height height
                                             :left-fringe 10
                                             :right-fringe 10))
                     (lsp-proxy--info "%s" "No content at point.")))))

  (general-def
    :keymaps 'lsp-proxy-mode-map
    "gt" 'lsp-proxy-find-type-definition)

  )


(provide 'init-lsp-proxy)
