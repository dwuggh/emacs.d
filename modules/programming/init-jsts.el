(setq-default js-indent-level 2)

(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook 'lsp)
  (add-hook 'js-mode-hook 'lsp)
  ;; (add-to-list 'auto-mode-alist '("\\.[jt]sx\\'" . typescript-mode))
  )

(with-eval-after-load 'typescript-ts-mode
  (add-hook 'typescript-ts-mode-hook #'lsp)
  )

(use-package rainbow-mode)

(use-package web-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.wxml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  )

(use-package json-mode
  :defer t
  :init
  (add-to-list 'auto-mode-alist '("\\.json\\'" . json-mode))
  )



(use-package css-mode
  :defer t
  :ensure nil
  :config
  (defun css-lookup-symbol-at-point ()
    "See `css-lookup-symbol'"
    (interactive)
    (css-lookup-symbol (my-thing-at-point)))
  (general-def
    :keymaps 'css-mode-map
    "K" 'css-lookup-symbol-at-point
    )
  )


(provide 'init-jsts)
