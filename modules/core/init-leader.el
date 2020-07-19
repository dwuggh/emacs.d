;; -*- lexical-binding: t; -*-

;; init `which-key' and `general'


(use-package which-key
  :init
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.2
        which-key-idle-secondary-delay 0.01
        which-key-enable-extended-define-key t
        which-key-add-column-padding 1
        which-key-max-description-length 32
        which-key-max-display-columns nil
        which-key-min-display-lines 6
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
        dwuggh--localleader ","
        dwuggh--localleader+ "\M-c")
  (general-create-definer dwuggh/leader-def
    :prefix dwuggh--leader
    :keymaps 'override)
  (general-create-definer dwuggh/localleader-def
    :prefix dwuggh--localleader)
  (general-create-definer dwuggh/localleader-def+
    :prefix dwuggh--localleader+)
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
 "w" '(:ignore t :wk "window")
 "g" '(:ignore t :wk "git")
 "q" '(:ignore t :wk "quit")


 ;; single commands
 "SPC" '(counsel-M-x :wk "M-x")

 ;; buffer
 "bm" '((lambda () (interactive) (switch-to-buffer "*Messages*")) :wk "message buffer")

 ;; file
 ;; search
 ;; window

 )


(provide 'init-leader)
;;; init-leader.el ends here
