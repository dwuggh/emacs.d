;;; -*- lexical-binding: t; -*-

(use-package smartparens
  :defer t
  :commands (sp-split-sexp sp-newline sp-up-sexp)
  :init
  (setq sp-show-pair-delay 0.1
        sp-show-pair-from-inside t
        ;; from spacemacs, dit look up
        sp-cancel-autoskip-on-backward-movement nil
        sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil
        )
  (add-hook+ '(prog-mode-hook comint-mode-hook)
             'smartparens-mode))








(provide 'init-editor)
;;; init-editor.el ends here
