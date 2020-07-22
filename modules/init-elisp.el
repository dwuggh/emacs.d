;;; -*- lexical-binding: t; -*-

(require 'lib-hack)

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode)
  )

;;; the helpful will be extremely useful
;;; ------------------------------------------------------------------------------

(use-package helpful
  :straight (helpful :type git :host github :repo "Wilfred/helpful")
  :config
  (setq helpful-switch-buffer-function 'pop-to-buffer)
  (global-set-key (kbd "C-h k") 'helpful-key)
  ;; (general-def
  ;;   :state 'normal
  ;;   :keymaps 'helpful-mode-map
  ;;   "RET" 'helpful-visit-reference
  ;;  )
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)
  )


(defun my-helpful-navigate (button)
  "Override the `helpful--navigate' function"
  (let ((path (substring-no-properties (button-get button 'path))))
      ;; (winum-select-window-1)
      (select-window my-window-cache)
      (find-file path)
      ;; (popwin:select-popup-window)
     (when-let (pos (get-text-property button 'position
                                       (marker-buffer button)))
       (goto-char pos))))


(advice-add 'helpful--navigate :override 'my-helpful-navigate)
;; (advice-remove 'helpful--navigate 'my-helpful-navigate)

(use-package elisp-slime-nav
  :init
  (dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
    (add-hook hook 'turn-on-elisp-slime-nav-mode))
  )


;; jump inside lisp code

(setq elisp-jump-handler
      '(elisp-slime-nav-find-elisp-thing-at-point
       counsel-etags-find-tag-at-point))

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

;;; localleader key setting
;;; -------------------------------------------------------------------------------------

(general-def
  :keymaps 'elisp-slime-nav-mode-map
  :major-modes 'emacs-lisp-mode
  "K" 'helpful-at-point)

(dwuggh/localleader-def
 :keymaps '(emacs-lisp-mode-map helpful-mode-map help-mode-map)
 "hh" '(helpful-at-point :wk "help at point")
 "hH" '(elisp-slime-nav-describe-elisp-thing-at-point :wk "slime help")
 "gg" '(my-elisp-navigation :wk "jump to definition")
 "'" '(ielm :wk "open ielm")
 )


;; TODO use the macro
;; (setq-modes-local (emacs-lisp-mode lisp-interaction-mode)
;;                  company-backends
;;                  '((company-elisp company-dabbrev-code :with company-yasnippet)
;;                    (company-capf company-dabbrev)))


;; TODO didn't work
(setq-mode-local lisp-interaction-mode
                  company-backends
                  '((company-capf company-dabbrev-code :with company-yasnippet company-elisp)
                    (company-capf company-dabbrev)))

(setq-mode-local emacs-lisp-mode
                  company-backends
                  '((company-capf company-dabbrev-code :with company-yasnippet company-elisp)
                    company-dabbrev))


(provide 'init-elisp)
