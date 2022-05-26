(setq-default js-indent-level 2)
(use-package typescript-mode
  :init
  (setq typescript-indent-level 2)
  (add-hook 'typescript-mode-hook 'my-lsp-init)
  (add-hook 'js-mode-hook 'my-lsp-init)
  (add-to-list 'auto-mode-alist '("\\.[jt]sx\\'" . typescript-mode))
  )

(use-package rainbow-mode)

;; (use-package tide
;;   :defer t
;;   :init
;;   (add-hook 'typescript-mode-hook 'tide-setup)
;;   (dwuggh/localleader-def
;;    :keymaps 'typescript-mode-map
;;    "gg" 'tide-jump-to-definition
;;    "gb" 'tide-jump-back
;;    "gi" 'tide-jump-to-implementation
;;    "hh" 'tide-documentation-at-point
;;    "gr" 'tide-references
;;    "rr" 'tide-rename-symbol
;;    "rf" 'tide-rename-file
;;    )
;;   (push '("*tide-documentation*"
;;  :dedicated t :position bottom
;;  :stick t :noselect nil :height 0.4)
;;  popwin:special-display-config)
;;   )

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

(defun css-lookup-symbol-at-point ()
  "See `css-lookup-symbol'"
  (interactive)
  (css-lookup-symbol (my-thing-at-point)))


(use-package css-mode
  :defer t
  :config
  (general-def
    :keymaps 'css-mode-map
    "K" 'css-lookup-symbol-at-point
    )
  )


(provide 'init-jsts)
