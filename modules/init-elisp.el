;;; -*- lexical-binding: t; -*-

(require 'lib-hack)

(use-package highlight-quoted
  :hook (emacs-lisp-mode . highlight-quoted-mode)
  )

;;; helper packages
;;; ------------------------------------------------------------------------------

(use-package explain-pause-mode
  :straight (explain-pause-mode :type git :host github :repo "lastquestion/explain-pause-mode")
  :config
  ;; (explain-pause-mode)
  )

(defun my-popwin-pop-to-buffer (buffer &optional other-window norecord)
  "my `popwin:pop-to-buffer'. It works."
  (interactive (list (read-buffer "Pop to buffer: " (other-buffer))
                     (if current-prefix-arg t)))
  (pcase (treemacs-current-visibility)
    ('visible (treemacs)
          (popwin:pop-to-buffer buffer other-window norecord)
          (treemacs)
          (popwin:select-popup-window)
          )
    ('exists
     (popwin:pop-to-buffer buffer other-window norecord)
     (popwin:select-popup-window)
     )
    ('none
    (popwin:pop-to-buffer buffer other-window norecord)
    (popwin:select-popup-window))
    )
  )
(use-package helpful
  :straight (helpful :type git :host github :repo "Wilfred/helpful")
  :config
  (setq helpful-switch-buffer-function 'my-popwin-pop-to-buffer)
  (setq helpful-switch-buffer-function 'pop-to-buffer)
  ;; (setq helpful-switch-buffer-function 'popwin:pop-to-buffer)
  (global-set-key (kbd "C-h k") 'helpful-key)
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h o") #'helpful-symbol)

  ;; config popwin
  (push
   '(helpful-mode :dedicated nil :position bottom :stick nil :noselect t :height 0.4)
   popwin:special-display-config)
  (general-def
    :state 'normal
    :keymaps 'helpful-mode-map
    "K" 'helpful-at-point
    ;; "RET" 'helpful-visit-reference
   )
  )


(defun my-helpful-navigate (button)
  "Override the `helpful--navigate' function"
  (let ((path (substring-no-properties (button-get button 'path))))
      ;; (winum-select-window-1)
    (call-interactively
     (popwin:close-popup-window)
     (winum-select-window-by-number my-window-number-cache)
     (find-file path)
     )
      ;; (popwin:select-popup-window)
     (when-let (pos (get-text-property button 'position
                                       (marker-buffer button)))
       (goto-char pos))
     ))


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
        ))

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

(use-package parinfer-rust-mode
  ;; :hook emacs-lisp-mode
  )

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
 ;; "ga" '(my-ivy-goto-definition :wk "find and go to definition")
 "'" '(ielm :wk "open ielm")
 )

;; (general-def
;;  :keymaps 'override
;;  "C-h g" '(my-ivy-goto-definition :wk "find and go to definition")
;;   )

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


;; hacking emacs
;;; ------------------------------------------------------------------------------------
(use-package s)


(provide 'init-elisp)
