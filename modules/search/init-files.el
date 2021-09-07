;;; -*- lexical-binding: t; -*-


(use-package recentf
  :init
  (setq recentf-save-file (concat user-emacs-directory ".cache/recentf")
        recentf-max-saved-items 2000
        recentf-max-menu-items 2000
        )
  (recentf-mode t)
  )

(use-package sync-recentf
  :straight
  (sync-recentf :type git :host github
         :repo "ffevotte/sync-recentf")
  :init
  (setq recentf-auto-cleanup 60)
  )

(use-package rg)

(defun xdg-open-file-1 (file)
  "Open FILE with xdg-open."
  (call-process "xdg-open" nil 0 nil file)
  )

(defun xdg-open-file (&optional initial-input)
  "Open selected file with xdg-open.
When INITIAL-INPUT is non-nil, use it in the minibuffer during completion."
  (interactive)
  (counsel--find-file-1
   "xdg-open file: " initial-input
   #'xdg-open-file-1
   'my-xdg-open
   )
  )

;;;###autoload
(defun my-consult-recent-file ()
  "Find recent file using `completing-read'. No preview."
  (interactive)
  (find-file
   (consult--read
    (or (mapcar #'abbreviate-file-name recentf-list)
        (user-error "No recent files, `recentf-mode' is %s"
                    (if recentf-mode "on" "off")))
    :prompt "Find recent file: "
    :sort nil
    :require-match t
    :category 'file
    ;; :state (consult--file-preview)
    :history 'file-name-history))
  )

(defvar my-find-file-map
  (let ((map (make-composed-keymap nil vertico-map)))
    (define-key map "/" #'my-find-file-/)
    (define-key map (kbd "C-h") #'my-find-file-C-h)
    map)
  "Find file keymap derived from `vertico-map'.")

(defun my-find-file-/ ()
  (interactive)
  (if (< vertico--index 0)
      (insert "/")
    (let ((file-or-dir (vertico--candidate)))
      (if (s-ends-with? "/" file-or-dir)
          (progn
            (delete-minibuffer-contents)
            (insert file-or-dir))
        (insert "/")))))

(defun my-find-file-C-h ()
  (interactive)
  (let* ((input (car vertico--input))
         (parent (f-parent input))
         (parent (if (s-ends-with? "/" parent) parent (concat parent "/")))
         )
    (cond
     ((s-equals? input "/"))
     (parent
      (delete-minibuffer-contents)
      (insert parent)
      )
     ;; TODO
     (t (delete-backward-char))
     )
    )
  )

(defun my-find-file-advice-vertico--setup (&rest args)
  (use-local-map my-find-file-map)
  )

;;; https://emacs.stackexchange.com/questions/16490/emacs-let-bound-advice
;;; also see `undo-fu--with-advice'
(defmacro with-advice (args &rest body)
  (declare (indent 1))
  (let ((fun-name (car args))
        (advice   (cadr args))
        (orig-sym (make-symbol "orig")))
    `(cl-letf* ((,orig-sym  (symbol-function ',fun-name))
                ((symbol-function ',fun-name)
                 (lambda (&rest args)
                   (apply ,advice ,orig-sym args))))
       ,@body)))

(defun my-find-file ()
  (interactive)
  (unwind-protect
      (progn
          (advice-add 'vertico--setup :after #'my-find-file-advice-vertico--setup)
          (call-interactively 'find-file)
        )
    (advice-remove 'vertico--setup #'my-find-file-advice-vertico--setup)
    )
  )

(dwuggh/leader-def
 "fr" '(my-consult-recent-file :wk "find recent files")
 "ff" '(my-find-file :wk "find files in current dir")
 "fs" '(save-buffer :wk "save file")
 "fS" '(evil-write-all :wk "save all file")
 "fz" 'counsel-fzf
 )

(provide 'init-files)
