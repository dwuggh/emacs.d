;;; -*- lexical-binding: t; -*-

(require 'lib-hack)

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode)
  )

;;; helper packages
;;; ------------------------------------------------------------------------------

(use-package explain-pause-mode
  :elpaca (explain-pause-mode :type git :host github :repo "lastquestion/explain-pause-mode")
  :config
  ;; (explain-pause-mode)
  )

(use-package elisp-slime-nav
  :init
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook 'turn-on-elisp-slime-nav-mode))
  (setq elisp-jump-handler
        '(elisp-slime-nav-find-elisp-thing-at-point
          ))
  )


(use-package helpful
  :elpaca (helpful :type git :host github :repo "Wilfred/helpful")
  :defer t
  :init
  (global-set-key (kbd "C-h k") 'helpful-key)
  (global-set-key (kbd "C-h C-k") 'helpful-key)
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h o") #'helpful-symbol)
  ;; helpful--update-and-switch-buffer
  :config
  ;; (add-hook 'helpful-mode-hook #'hide-mode-line-popup)
  ;; TODO if in `helpful-symbol', if symbol is a face, then require special advice.
  ;; (advice-add 'helpful--update-and-switch-buffer :override 'hide-mode-line-popup)
  ;; (advice-remove 'helpful--update-and-switch-buffer 'hide-mode-line-popup)

  (general-def
    :keymaps 'elisp-slime-nav-mode-map
    :major-modes 'emacs-lisp-mode
    "K" 'helpful-at-point)
  )



(defun my-elisp-navigation (&optional jump-handler)
  "Jump to definition around point using the best tool for this action.
`spacemacs/jump-to-definition'"
  (interactive)
  (catch 'done
    (let ((old-buffer (current-buffer))
          (old-point (point)))
      (dolist (-handler elisp-jump-handler)
        (let ((handler (if (listp -handler) (car -handler) -handler))
              (async (when (listp -handler)
                       (plist-get (cdr -handler) :async))))
          (ignore-errors
            (call-interactively handler))
          (when (or (eq async t)
                    (and (fboundp async) (funcall async))
                    (not (eq old-point (point)))
                    (not (equal old-buffer (current-buffer))))
            (throw 'done t)))))
    (message "No jump handler was able to find this symbol.")))



(use-package erefactor
  :defer t
  :init
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (define-key emacs-lisp-mode-map "\C-c\C-v" erefactor-map))))

;;; localleader key setting
;;; -------------------------------------------------------------------------------------


(dwuggh/localleader-def
 :keymaps '(emacs-lisp-mode-map helpful-mode-map help-mode-map)
 "hh" '(helpful-at-point :wk "help at point")
 "hH" '(elisp-slime-nav-describe-elisp-thing-at-point :wk "slime help")
 "gg" '(my-elisp-navigation :wk "jump to definition")
 "'" '(ielm :wk "open ielm")
 )
(general-define-key
  :state 'normal
  :keymaps '(helpful-mode-map emacs-lisp-mode-map)
  "K" 'helpful-at-point
  ;; "RET" 'helpful-visit-reference
  )


;; TODO use the macro
;; (setq-modes-local (emacs-lisp-mode lisp-interaction-mode)
;;                  company-backends
;;                  '((company-elisp company-dabbrev-code :with company-yasnippet)
;;                    (company-capf company-dabbrev)))


;; TODO didn't work
(setq-mode-local lisp-interaction-mode
                 company-backends
                 '((company-capf :with company-yasnippet)  company-elisp company-dabbrev-code 
                   company-dabbrev))

(setq-mode-local emacs-lisp-mode
                 company-backends
                 '((company-capf :with company-yasnippet)  company-elisp company-dabbrev-code
                   company-dabbrev))


;;; ------------------------------------------------------------------------------------


(provide 'init-elisp)
