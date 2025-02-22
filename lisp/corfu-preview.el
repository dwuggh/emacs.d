
;; Customize the preview face
(defface corfu-preview-face
  '((t :inherit shadow))
  "Face used for the preview of the first candidate.")

(defvar-local corfu-preview--overlay nil)

(defun corfu-preview--overlay-visible ()
      (and (overlayp corfu-preview--overlay)
          (overlay-buffer corfu-preview--overlay)))

(defun corfu-preview--overlay-delete ()
      (if (corfu-preview--overlay-visible)
          (delete-overlay corfu-preview--overlay)))

(defun corfu-preview-current-alt ()
  (let* ((beg (car completion-in-region--data))
         (end (cadr completion-in-region--data)))
    (corfu-preview-current-1 beg end)))

(defun corfu-preview-current-1 (beg end)
  (when corfu--candidates
    (corfu-preview--overlay-delete)
    (let* ((candidate (nth corfu--index corfu--candidates))
           (beg (if (markerp beg) (marker-position beg) beg))
           (end (if (markerp end) (marker-position end) end))
           (beg (+ beg (length corfu--base)))
           (ov (make-overlay beg end))
           (content (corfu-preview--propertize
                    (buffer-substring-no-properties beg end)
                    candidate 'default))
           )
      (overlay-put ov 'display content)
      (overlay-put ov 'priority 1000)
      (overlay-put ov 'window (selected-window))
      (setq corfu-preview--overlay ov))))


(defun corfu-preview--propertize (input candidate input-face)
  (let ((str (propertize candidate 'corfu-preview t))
        (pos (length input))
        (end (length candidate)))
    (message "input %s at %d with candidate %s" input pos candidate)
    (put-text-property 0 pos 'face input-face str)
    (when (< pos end)
      (put-text-property pos (1+ pos) 'cursor pos str))
    (put-text-property pos end 'face 'corfu-preview-face str)
    str
    )
  )

(define-minor-mode corfu-preview-mode
  "show virtual 1st candidate."
  ;; :global t
  :group 'corfu
  (if corfu-preview-mode
      (progn
        (advice-add 'corfu--preview-current :override 'corfu-preview-current-1)
        (advice-add 'corfu--preview-delete :override 'corfu-preview--overlay-delete))
    (advice-remove 'corfu--preview-current 'corfu-preview-current-1)
    (advice-remove 'corfu--preview-delete 'corfu-preview--overlay-delete)
    ))




(provide 'corfu-preview)
