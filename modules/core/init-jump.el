;;; -*- lexical-binding: t; -*-

(use-package avy
  :init
  (setq avy-timeout-seconds 0.2
        avy-all-windows t
        avy-background t)
  )

(dwuggh/leader-def
 "jj" '(evil-avy-goto-char-timer :wk "char timer")
 "jl" '(evil-avy-goto-line :wk "goto line")
 "jo" '(evil-avy-goto-line-above :wk "goto line above")
 "j." '(evil-avy-goto-line-below :wk "goto line below")
 "jw" '(evil-avy-goto-word-1 :wk "goto word")
 "jb" '(avy-pop-mark :wk "go back")
 )

(provide 'init-jump)
