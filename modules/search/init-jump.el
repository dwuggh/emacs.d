;;; -*- lexical-binding: t; -*-

(use-package avy
  :init
  (setq avy-timeout-seconds 0.2
        avy-all-windows t
        avy-background t)
  )

(dwuggh/leader-def
 "jj" '(evil-avy-goto-char-timer :wk "char timer")
 "ji" '(counsel-imenu :wk "imenu")
 "jl" '(evil-avy-goto-line :wk "goto line")
 "jo" '(evil-avy-goto-line-above :wk "goto line above")
 "j." '(evil-avy-goto-line-below :wk "goto line below")
 "jw" '(evil-avy-goto-word-1 :wk "goto word")
 "jb" '(avy-pop-mark :wk "go back")

 "bb" '(ivy-switch-buffer :wk "change buffer")
 )


;; tags
(use-package counsel-etags
  ;; :bind (("C-]" . counsel-etags-find-tag-at-point))
  :init
  (add-hook 'prog-mode-hook
        (lambda ()
          (add-hook 'after-save-hook
            'counsel-etags-virtual-update-tags 'append 'local)))
  :config
  (setq counsel-etags-update-interval 60)
  (push "build" counsel-etags-ignore-directories)
  (push "build-debug" counsel-etags-ignore-directories)
  (push ".cache" counsel-etags-ignore-directories)
  (push "*.json" counsel-etags-ignore-filenames)
  )

(dwuggh/localleader-def
 :major-modes 'prog-mode
 "gg" 'counsel-etags-find-tag-at-point
 "gl" '(counsel-etags-list-tag-in-current-file :wk "list tags")
 )


(provide 'init-jump)
