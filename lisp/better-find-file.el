
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
      (insert
       (if (s-starts-with? (expand-file-name "~/") parent)
           (->> parent
                (s-chop-prefix (expand-file-name "~/"))
                (s-prepend "~/"))
         parent)
       )
      )
     ;; TODO
     (t (delete-backward-char))
     )
    )
  )

(defun my-find-file-advice-vertico--setup (&rest args)
  (use-local-map my-find-file-map)
  )

;;;###autoload
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

(provide 'better-find-file)
