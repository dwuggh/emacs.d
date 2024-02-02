
;; (use-package tree-sitter
;;   :defer t
;;   :init
;;   (add-hook 'prog-mode-hook #'turn-on-tree-sitter-mode)
;;   :config
;;   ;; (require 'tree-sitter-langs)
;;   (use-package tree-sitter-langs)
;;   (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
;;   )
;; ;; (global-tree-sitter-mode)
;; (use-package evil-textobj-tree-sitter
;;   :straight (evil-textobj-tree-sitter :type git
;;                                       :host github
;;                                       :repo "meain/evil-textobj-tree-sitter"
;;                                       :files (:defaults "queries"))
;;   ;; :defer t
;;   :after tree-sitter
;;   :config
;;   ;; (evil-define-key '(visual operator) 'tree-sitter-mode
;;   ;;   "i" +tree-sitter-inner-text-objects-map
;;   ;;   "a" +tree-sitter-outer-text-objects-map)
;;   ;; (evil-define-key 'normal 'tree-sitter-mode
;;   ;;   "[g" +tree-sitter-goto-previous-map
;;   ;;   "]g" +tree-sitter-goto-next-map)

;;   ;; bind `function.outer`(entire function block) to `f` for use in things like `vaf`, `yaf`
;;   (define-key evil-outer-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.outer"))
;;   ;; bind `function.inner`(function block without name and args) to `f` for use in things like `vif`, `yif`
;;   (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))

;;   ;; You can also bind multiple items and we will match the first one we can find
;;   (define-key evil-outer-text-objects-map "a" (evil-textobj-tree-sitter-get-textobj ("conditional.outer" "loop.outer")))
;;   )

(defun my-run-make ()
  "run make in current dir"
  (interactive)
  (async-shell-command "make" "*my-run-make-log*" "*my-run-make-error*")
  )

(setq display-buffer-alist
      (cons '("\\*my-run-make-*" display-buffer-no-window)
            display-buffer-alist))



(require 'init-python)
(require 'init-jsts)
(require 'init-go)

(provide 'init-programming)
