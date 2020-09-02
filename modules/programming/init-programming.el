
(use-package leetcode
  :defer t
  :config
  (define-key leetcode--problems-mode-map (kbd "TAB") 'leetcode-show-current-problem)
  (define-key leetcode--problems-mode-map (kbd "<return>") 'leetcode-show-current-problem)
  (setq leetcode-directory "~/Documents/leetcode"
	leetcode-prefer-language "cpp")
  )

(straight-use-package
 '(tree-sitter :host github
               :repo "ubolonton/emacs-tree-sitter"
               :files ("lisp/*.el")))

(straight-use-package
 '(tree-sitter-langs :host github
                     :repo "ubolonton/emacs-tree-sitter"
                     :files ("langs/*.el" "langs/queries")))

(use-package tree-sitter-langs)
(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
(global-tree-sitter-mode)



(require 'init-python)
(require 'init-java)
(require 'init-jsts)

(provide 'init-programming)
