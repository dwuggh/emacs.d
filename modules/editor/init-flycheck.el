
(use-package flycheck
  :commands flycheck-list-errors flycheck-buffer
  :config
  ;;; from doom emacs
  (define-fringe-bitmap 'flycheck-fringe-bitmap-double-arrow
      [16 48 112 240 112 48 16] nil nil 'center)
  (setq flycheck-indication-mode 'right-fringe)
  ;; And don't recheck on idle as often
  (setq flycheck-idle-change-delay 1.0)

  ;; For the above functionality, check syntax in a buffer that you switched to
  ;; only briefly. This allows "refreshing" the syntax check state for several
  ;; buffers quickly after e.g. changing a config file.
  (setq flycheck-buffer-switch-check-intermediate-buffers t)
  
  ;; Display errors a little quicker (default is 0.9s)
  (setq flycheck-display-errors-delay 0.25)


  (global-flycheck-mode 1)
  )

(defvar my/flycheck-error-popup--timer nil
  "Timer to hide the Flycheck error popup after a delay.")

(defvar my/flycheck-error-popup--buffer "*flycheck-error-popup*"
  "Buffer name for the Flycheck error popup.")

(defun my/flycheck-error-popup--hide ()
  "Hide the Flycheck error popup."
  (posframe-hide my/flycheck-error-popup--buffer))

(defun my/flycheck-error-popup--show ()
  "Show the Flycheck error at point in a posframe."
  (let ((error-message (flycheck-explain-error-at-point)))
    (when error-message
      (posframe-show
       my/flycheck-error-popup--buffer
       :string error-message
       :position (point)
       :min-width 80
       :max-width 80
       :min-height 5
       :max-height 10
       ;; :background-color "#1c1c1c"
       ;; :foreground-color "#ffffff"
       :border-width 1
       :border-color "#ffffff")
      (with-current-buffer my/flycheck-error-popup--buffer
        (markdown-mode)
        (tab-line-mode -1)
        )
      )))

(defun my/flycheck-error-popup ()
  "Display Flycheck error at point in a posframe and auto-hide it after a delay."
  (interactive)
  (my/flycheck-error-popup--show)
  (when my/flycheck-error-popup--timer
    (cancel-timer my/flycheck-error-popup--timer))
  (setq my/flycheck-error-popup--timer
        (run-with-idle-timer 5 nil 'my/flycheck-error-popup--hide)))

;; Hide the popup on cursor movement or command execution



(defmacro defadvice! (symbol arglist &optional docstring &rest body)
  "Define an advice called SYMBOL and add it to PLACES.

ARGLIST is as in `defun'. WHERE is a keyword as passed to `advice-add', and
PLACE is the function to which to add the advice, like in `advice-add'.
DOCSTRING and BODY are as in `defun'.

\(fn SYMBOL ARGLIST &optional DOCSTRING &rest [WHERE PLACES...] BODY\)"
  (declare (doc-string 3) (indent defun))
  (unless (stringp docstring)
    (push docstring body)
    (setq docstring nil))
  (let (where-alist)
    (while (keywordp (car body))
      (push `(cons ,(pop body) (ensure-list ,(pop body)))
            where-alist))
    `(progn
       (defun ,symbol ,arglist ,docstring ,@body)
       (dolist (targets (list ,@(nreverse where-alist)))
         (dolist (target (cdr targets))
           (advice-add target (car targets) #',symbol))))))

(use-package flycheck-popup-tip
  :defer t
  :init
  (defun flycheck-popup-tip-init ()
    "Activate `flycheck-posframe-mode' if available and in GUI Emacs.
Activate `flycheck-popup-tip-mode' otherwise.
Do nothing if `lsp-ui-mode' is active and `lsp-ui-sideline-enable' is non-nil."
    (unless (and (bound-and-true-p lsp-ui-mode)
                 lsp-ui-sideline-enable)
      (flycheck-popup-tip-mode +1)))
  (add-hook 'flycheck-mode-hook 'flycheck-popup-tip-init)
  :commands flycheck-popup-tip-show-popup flycheck-popup-tip-delete-popup
  :config
  (setq flycheck-popup-tip-error-prefix "X ")
  (add-hook 'evil-insert-state-entry-hook #'flycheck-popup-tip-delete-popup)
  (add-hook 'evil-replace-state-entry-hook #'flycheck-popup-tip-delete-popup)
  (defadvice! +syntax--disable-flycheck-popup-tip-maybe-a (&rest _)
      :before-while #'flycheck-popup-tip-show-popup
      (if evil-local-mode
          (eq evil-state 'normal)
        (not (bound-and-true-p company-backend))))

  )

(dwuggh/leader-def
 "e" '(consult-flycheck :wk "flycheck errors")
 )


(provide 'init-flycheck)
