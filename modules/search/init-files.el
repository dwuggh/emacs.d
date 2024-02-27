;;; -*- lexical-binding: t; -*-


(use-package recentf
  :ensure nil
  :init
  (setq recentf-save-file (concat user-emacs-directory ".cache/recentf")
        recentf-max-saved-items 2000
        recentf-max-menu-items 2000
        )
  (recentf-mode t)
  )

(use-package sync-recentf
  :ensure
  (sync-recentf :type git :host github
                :repo "ffevotte/sync-recentf")
  :init
  (setq recentf-auto-cleanup 60)
  :config
  (add-to-list 'recentf-exclude (concat "^" sync-recentf-marker))
  (add-to-list 'recentf-exclude
         (concat "^" (recentf-expand-file-name my-cache-dir) "*"))
  )

(use-package rg)

(defun xdg-open-file-1 (file)
  "Open FILE with xdg-open."
  (call-process "xdg-open" nil 0 nil (expand-file-name file))
  )

;;;###autoload
(defun xdg-open-file (&optional initial-input)
  "Open selected file with xdg-open.
When INITIAL-INPUT is non-nil, use it in the minibuffer during completion."
  (interactive)
  ;; TODO
  (xdg-open-file-1
   (read-file-name "xdg-open file: " default-directory initial-input t))
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


(provide 'init-files)
