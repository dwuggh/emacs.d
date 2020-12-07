
(use-package leetcode
  :defer t
  :config
  (define-key leetcode--problems-mode-map (kbd "TAB") 'leetcode-show-current-problem)
  (define-key leetcode--problems-mode-map (kbd "<return>") 'leetcode-show-current-problem)
  (setq leetcode-directory "~/Documents/leetcode"
	leetcode-prefer-language "cpp")
  )


;; (straight-register-package
;;  '(tsc :host github
;;        :repo "ubolonton/emacs-tree-sitter"
;;        :no-build t
;;        :files ("core/*.el"))
;;  )

;; (straight-use-package tsc)
;; (straight--add-package-to-load-path
;;  '(tsc :host github
;;        :repo "ubolonton/emacs-tree-sitter"
;;        :files ("core/*.el"))
;;  )

;; (with-temp-file tsc-dyn-get--version-file
;;       (let ((coding-system-for-write 'utf-8))
;;         (insert "0.12.0")))

(setq load-path 
      (cons (expand-file-name
	     (concat straight-base-dir "straight/build/tsc"))
	    load-path))


;; Base framework, syntax highlighting.
(straight-use-package
 '(tree-sitter :host github
               :repo "ubolonton/emacs-tree-sitter"
               :files ("lisp/*.el")))
;; Language bundle.
(straight-use-package
 '(tree-sitter-langs :host github
                     :repo "ubolonton/emacs-tree-sitter"
                     :files ("langs/*.el" "langs/queries")))

(use-package tree-sitter-langs)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(global-tree-sitter-mode)

(setq-default tab-width 4)

(defun my-run-make ()
  "run make in current dir"
  (interactive)
  (async-shell-command "make" "*my-run-make-log*" "*my-run-make-error*")
)

(setq display-buffer-alist
      (cons '("\\*my-run-make-*" display-buffer-no-window)
	    display-buffer-alist))

(require 'init-python)
(require 'init-java)
(require 'init-jsts)
(require 'init-cool)

(provide 'init-programming)
