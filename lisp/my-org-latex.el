;; my latex preview for org

(require 'ov)

;; see `org--make-preview-overlay'

(defvar my-org-latex-preview-program
  "tex2img convert "
  )

(defun my-org-latex-get-img-path (text)
  (s-trim (shell-command-to-string
           (s-concat my-org-latex-preview-program "'" text "'"))))

;; (my-org-latex-get-img-path "$a$")

(defun check-ov ()
  (interactive)
  (prin1(ov-prop (ov-at)))
  )
;; (init-image-library 'svg)

(defun my-org-latex-preview-make-ov (beg end img)
  (let ((imgov (ov beg end
                   'evaporate t
                   'org-overlay-type 'org-latex-overlay
                   'display
                   `(image :type svg :file ,img :ascent center)
                   'modification-hooks
                   '(lambda (o _flag _beg _end &optional _l)
                      (delete-overlay o))
                   )))
    imgov
    )
  )

(defun my-org--latex-preview-region (beg end)
  "Preview LaTeX fragments between BEG and END.
BEG and END are buffer positions.
As a replacement of `org--latex-preview-region'.
"
  (save-excursion
    (goto-char (or beg (point-min)))
    (while (< (point) (or end (point-max)))
      (when (org-inside-latex-environment-p)
        (let* ((ele (org-element-context))
               ;; (ele-type (org-element-type ele))
               (ele-val (org-element-property :value ele))
               (ele-beg (org-element-property :begin ele))
               (ele-end (org-element-property :end ele))
               (text (buffer-substring-no-properties ele-beg ele-end))
               (imgpath (my-org-latex-get-img-path text))
               )
          (dolist (o (overlays-in beg end))
                (when (eq (overlay-get o 'org-overlay-type)
                      'org-latex-overlay)
                  (delete-overlay o)))
          (my-org-latex-preview-make-ov ele-beg ele-end imgpath)
          ;; (prin1 ele)
          ;; (prin1 imgpath) ;; works well here
          (goto-char ele-end)
          )
        )
      (forward-char)
      )
    )
  )

;; (advice-add 'org--latex-preview-region :override 'my-org--latex-preview-region)
;; (advice-remove 'org--latex-preview-region 'my-org--latex-preview-region)
