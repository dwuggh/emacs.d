;;; company-org-latex.el --- completion-at-point functions for latex in org-mode -*- lexical-binding: t; -*-


(defun org-inside-latex-environment-p ()
  (or
   (org-inside-LaTeX-fragment-p)
   (org-inside-latex-macro-p)
   )
  )

(defmacro looking-back-match (regexp)
  `(when (looking-back ,regexp)
     (match-string-no-properties 1))
  )

(defmacro company-auctex-symbols-all ()
  '(append (mapcar 'cadr (company-auctex-math-all))
          (mapcar 'car (company-auctex-get-LaTeX-font-list t)))
)

;;;###autoload
(defun org-latex-capf ()
  (when-let ((ele (org-inside-latex-environment-p)))
    (let* ((text (looking-back-match "\\\\\\([a-zA-Z]*\\)\\="))
           (beg  (- (point) (length text))))
      (message "triggered")
      (prin1 ele)
      (list beg (point)
            (company-auctex-symbols-all)
            ;; (-map 'cadr (company-auctex-math-all))
            :exclusive 'no
            :company-docsig #'identity
            :annotation-function #'company-auctex-symbol-annotation
            )
      )
    )
  )


(provide 'company-org-latex)
