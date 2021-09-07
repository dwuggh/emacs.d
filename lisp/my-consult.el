
(require 'consult)


(defun consult-find-file (&optional initial-input initial-directory)
  (interactive)
  )

;; (insert-file-contents)


(defvar my-consult-preview-buffer-name "*my-consult-preview-buffer*"
  "Temp buffer for `my-consult-buffer-display'."
  )

(get-file-buffer "~/config.json")
(file-attributes "~/config.json")

(defun my-consult-buffer-display (buffer-or-name &optional norecord)
  "Display BUFFER-OR-NAME contents with temp buffer."
  (if (get-buffer buffer-or-name)
      (switch-to-buffer buffer-or-name norecord)
    ;; preview contents with temp buffer
    (let ((buf (get-buffer-create my-consult-preview-buffer-name)))
      ;; (with-temp-buffer-window)
      (switch-to-buffer my-consult-preview-buffer-name)
      (erase-buffer)
      (insert-file-contents buffer-or-name)
      )
    )
  )


(setq consult--buffer-display #'my-consult-buffer-display)
