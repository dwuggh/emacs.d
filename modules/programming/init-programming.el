
(use-package leetcode
  :defer t
  :config
  (define-key leetcode--problems-mode-map (kbd "TAB") 'leetcode-show-current-problem)
  (define-key leetcode--problems-mode-map (kbd "<return>") 'leetcode-show-current-problem)
  (setq leetcode-directory "~/Documents/leetcode"
	leetcode-prefer-language "cpp")
  )

(require 'init-python)
(require 'init-java)

(provide 'init-programming)
