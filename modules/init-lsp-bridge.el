
;;; TODO
;; lsp-find-reference
;; lsp-diagnostics
;; evil-mode compatibility in view mode
;; documentation in popup buffer



(straight-use-package
 `(lsp-bridge :local-repo ,(concat user-emacs-directory "lisp/lsp-bridge/")
              :files ("*")))
(use-package lsp-bridge
  ;; :straight
  ;; (lsp-bridge :local-repo (concat user-emacs-directory "lisp/lsp-bridge/")
  ;;             :files ("*"))
  :init
  (setq lsp-bridge-python-command "python")
  ;; (setq lsp-bridge-enable-log t)
  :config
  ;; (require 'lsp-bridge)
  (setq popper-reference-buffers
        (cons lsp-bridge-lookup-doc-board popper-reference-buffers)
        )
  (setq-default lsp-bridge-default-mode-hooks
        (remove 'emacs-lisp-mode-hook lsp-bridge-default-mode-hooks))
  (global-lsp-bridge-mode)
  (define-key acm-mode-map (kbd "C-j") 'acm-select-next)
  (define-key acm-mode-map (kbd "C-k") 'acm-select-prev)
  (define-key evil-insert-state-map (kbd "C-k") nil)


  (evil-define-key* '(normal visual) lsp-bridge-mode-map (kbd "K") #'lsp-bridge-lookup-documentation)
  )


(defun lsp-bridge-reference (content num)
  ;; (print content)
  (consult--read
   (s-split "\n" content)
   :category 'consult-location
   :require-match t
   :sort nil
   ))

(setq rustic-lsp-setup-p nil)

(advice-add 'lsp-bridge-popup-references :override 'lsp-bridge-reference)

(defun my-lsp-init ()
  "My lsp initialization."
  )

(provide 'init-lsp-bridge)
