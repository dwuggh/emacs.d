
(require 'magic-latex-buffer)

(defun org-ml-jit-lock (beg end)
  (save-excursion
    (goto-char beg)
    (while (< (point) end)
      (let* ((ele (org-element-context))
             (ele-type (org-element-type ele))
             (ele-val (org-element-property :value ele))
             (ele-beg (org-element-property :begin ele))
             (ele-end (org-element-property :end ele))
             )
        (if (or (eq ele-type 'latex-environment)
                  (and (eq ele-type 'latex-fragment)
                       (or (string-prefix-p "\\[" ele-val)
                           (string-prefix-p "$$" ele-val)
                           (not (version< org-version "9.0"))))
                  (and (eq ele-type 'src-block)
                       (equal (plist-get (cadr ele) :language) "latex")))
          (progn
            (ml/jit-prettifier ele-beg ele-end)
            (ml/jit-block-highlighter ele-beg ele-end)
            (ml/jit-block-aligner ele-beg ele-end)
            (goto-char ele-end)
            (forward-char)
            )
          (forward-line)
          )
        )
      )
    )
  )

(define-minor-mode org-ml-mode
  "magic latex buffer in org-mode"
  :init-value nil
  :global nil
  (if org-ml-mode
      (progn
        (jit-lock-mode 1)
        (setq-local font-lock-multiline t)
        ;; (set-syntax-table ml/syntax-table)
        (font-lock-add-keywords nil ml/keywords)
        (jit-lock-register 'org-ml-jit-lock t)
        ;; (jit-lock-register 'font-lock-fontify-region)
        )
    (jit-lock-unregister 'org-ml-jit-lock)
    ;; (ml/remove-block-overlays (point-min) (point-max))
    ;; (ml/remove-pretty-overlays (point-min) (point-max))
    ;; (ml/remove-align-overlays (point-min) (point-max))
    (font-lock-refresh-defaults)
    ))

(provide 'org-ml)
