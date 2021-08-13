;; -*- lexical-binding: t; -*-

;; init `which-key' and `general'


(use-package which-key
  :init
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.7
        which-key-idle-secondary-delay 0.01
        which-key-add-column-padding 1
        which-key-max-description-length 32
        which-key-max-display-columns nil
        which-key-min-display-lines 4
        which-key-sort-order 'which-key-prefix-then-key-order
        which-key-sort-uppercase-first nil
        which-key-use-C-h-for-paging t
        which-key-allow-evil-operators t
        )

  (which-key-mode)
  )

(use-package general
  :config
  (setq general-default-states '(normal visual))
  (setq dwuggh--leader "SPC"
        dwuggh--localleader- ","
        dwuggh--localleader+ "\M-c")
  (general-create-definer dwuggh/leader-def
    :prefix dwuggh--leader
    :states '(normal visual motion)
    :keymaps 'override)
  (general-create-definer dwuggh/localleader-def-
    :prefix dwuggh--localleader-
    :states '(normal visual)
    ;; :keymaps 'override
    )
  (general-create-definer dwuggh/localleader-def+
    :prefix dwuggh--localleader+
    :states '(normal visual)
    ;; :keymaps 'override
    )
  )

(defmacro dwuggh/localleader-def (&rest args)
  "A wrapper."
    (eval (macroexpand
           `(,'dwuggh/localleader-def- ,@args)))
    (eval (macroexpand
           `(,'dwuggh/localleader-def+ ,@args)))
    )

(dwuggh/leader-def
 ;; :keymaps 'override
 ;; prefixs
 "b" '(:ignore t :wk "buffer")
 "f" '(:ignore t :wk "file")
 "c" '(:ignore t :wk "code/comment")
 "s" '(:ignore t :wk "search")
 "p" '(:ignore t :wk "project")
 "i" '(:ignore t :wk "insert")
 "j" '(:ignore t :wk "jump")
 "w" '(:ignore t :wk "window")
 "g" '(:ignore t :wk "git")
 "q" '(:ignore t :wk "quit")
 "qq" '(save-buffers-kill-terminal :wk "quit emacs")

 "u" 'universal-argument
 ;; single commands
 "SPC" '(execute-extended-command :wk "M-x")
 )

(dwuggh/localleader-def
 "h" '(:ignore t :wk "help")
 "g" '(:ignore t :wk "goto")
 "e" '(:ignore t :wk "eval")
 )

(provide 'init-leader)
;;; init-leader.el ends here
