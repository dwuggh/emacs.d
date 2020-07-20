
  (use-package rime
    :straight (rime :type git
                    :host github
                    :repo "DogLooksGood/emacs-rime"
                    :files ("*.el" "Makefile" "lib.c"))
    :config
    (defun rime-evil-escape-advice (orig-fun key)
      "advice for `rime-input-method' to make it work together with `evil-escape'.
Mainly modified from `evil-escape-pre-command-hook'"
      (when (featurep 'evil-escape)
        (let* (
               (fkey (elt evil-escape-key-sequence 0))
               (skey (elt evil-escape-key-sequence 1))
               (evt (read-event nil nil evil-escape-delay))
               )
          (cond
           ((and (characterp evt)
                 (or (and (char-equal key fkey) (char-equal evt skey))
                     (and evil-escape-unordered-key-sequence
                          (char-equal key skey) (char-equal evt fkey))))
            (evil-repeat-stop)
            ;; need 2 escape: one escapes from input method, the other one escapes from else
            (rime--escape)
            (evil-normal-state)
            (let ((esc-fun (evil-escape-func)))
              (when esc-fun
                (setq this-command esc-fun)
                (setq this-original-command esc-fun))))
           ((null evt) (apply orig-fun (list key)))
           (t
            (apply orig-fun (list key))
            (if (numberp evt)
                (apply orig-fun (list evt))
              (setq unread-command-events (append unread-command-events (list evt)))))))))

    (advice-add 'rime-input-method :around #'rime-evil-escape-advice)
    :custom
    (default-input-method "rime")
    :config
    (setq-default rime-show-candidate 'posframe)
    (setq-default rime-user-data-dir (concat user-emacs-directory "rime/")))

(use-package goldendict
  :defer t
  )

(use-package youdao-dictionary
  :defer t)


(dwuggh/leader-def
 "o" '(:ignore t :wk "Chinese")
 "ou" '(goldendict-dwim :wk "goldendict")
 "oy" '(youdao-dictionary-search-at-point+ :wk "youdao dict"))

(provide 'init-chinese)
