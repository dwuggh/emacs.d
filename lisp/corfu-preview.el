
;; Customize the preview face
(defface corfu-preview-face
  '((t :inherit shadow))
  "Face used for the preview of the first candidate.")

(defvar-local corfu-preview--overlay nil)

(defun corfu-preview--overlay-visible ()
      (and (overlayp corfu-preview--overlay)
          (overlay-buffer corfu-preview--overlay)))

(defun corfu-preview--overlay-delete-nocheck ()
  (delete-overlay corfu-preview--overlay)
  (setq corfu-preview--overlay nil))

(defun corfu-preview--overlay-delete ()
  (if (corfu-preview--overlay-visible)
      (corfu-preview--overlay-delete-nocheck)))

(defvar corfu-preview-only-1-candidate t)
  
(defun corfu-preview-condition ()
  (and corfu--candidates
       (if corfu-preview-only-1-candidate (eq corfu--total 1) t)))

(defun corfu-preview-current-1 (beg end)
  (when (corfu-preview-condition)
    (corfu-preview--overlay-delete)
    (let* ((candidate (nth corfu--index corfu--candidates))
           (beg (if (markerp beg) (marker-position beg) beg))
           (end (if (markerp end) (marker-position end) end))
           (beg (+ beg (length corfu--base)))
           (input (car corfu--input))
           (pos (cdr corfu--input))
           (suffix-content (if (string-prefix-p input candidate t)
                               (substring candidate (length input))
                             candidate)))
      (unless (string-empty-p suffix-content)
          (let ((suffix (corfu-preview--propertize suffix-content))
                (ov (make-overlay end end nil t t)))
            (overlay-put ov 'after-string suffix)
            (overlay-put ov 'priority 1000)
            (overlay-put ov 'window (selected-window))
            (setq corfu-preview--overlay ov))))))

(defun corfu-preview-current-1 (beg end)
  (when (corfu-preview-condition)
    (corfu-preview--overlay-delete)
    (let* ((candidate (nth corfu--index corfu--candidates))
           (beg (if (markerp beg) (marker-position beg) beg))
           (end (if (markerp end) (marker-position end) end))
           (beg (+ beg (length corfu--base)))
           (input (car corfu--input))
           (pos (cdr corfu--input))
           (ov (make-overlay beg end))
           (content (corfu-preview--propertize-2 input
                    candidate 'default))
           )
      (setq corfu-preview--current-candidate candidate)
      (overlay-put ov 'display content)
      (overlay-put ov 'priority 1000)
      (overlay-put ov 'window (selected-window))
      (setq corfu-preview--overlay ov))))

(defvar-local corfu-preview--current-candidate nil)

(defun corfu-preview--propertize-2 (input candidate input-face)
  (let ((str (propertize candidate 'corfu-preview t))
        (pos (length input))
        (end (length candidate)))
    ;; (message "input %s at %d with candidate %s" input pos candidate)
    (put-text-property 0 pos 'face input-face str)
    (when (< pos end)
      (put-text-property pos (1+ pos) 'cursor pos str))
    (put-text-property pos end 'face 'corfu-preview-face str)
    str
    )
  )

;; (setq corfu-auto-delay 0)
(defun corfu-preview--update-overlay-simple ()
  (corfu-preview--propertize-2 corfu--input corfu-preview--current-candidate 'default))

(defun corfu-preview--propertize (content)
  (let ((content (propertize content 'corfu-preview t 'face 'corfu-preview-face)))
    (put-text-property 0 1 'cursor 1 content)
    content))



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
