

(general-define-key)
(general-def
  :major-modes 'text-mode
  :states '(normal visual motion)
  "K" 'youdao-dictionary-search-at-point-posframe
  )

(require 'init-spell)
(require 'init-latex)
(require 'init-org)


(provide 'init-notes)
