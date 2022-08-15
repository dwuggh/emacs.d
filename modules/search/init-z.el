
(defun zoxide-query-l ()
  (s-split "\n" (shell-command-to-string "zoxide query -l"))
  )

(defun zoxide-query-ls ()
  (-map 's-trim (s-split "\n" (s-trim-right (shell-command-to-string "zoxide query -ls" ))))
  )

(defun zoxide-weighted-pair (text)
  "Get weight and directory."
  (->> text
      (s-match "^\\([0-9]+ \\)\\(.*\\)")
      (cdr)
      (-map-first (lambda (_) t) 'string-to-number)))

(defun ivy-zoxide-sort-function (a b)
  "Sort function for zoxide."
  (let ((w1 (car (zoxide-weighted-pair a)))
        (w2 (car (zoxide-weighted-pair b))))
    (> w1 w2)
    )
  )

(defun consult-z ()
  "Consult with zoxide"
  (interactive)
    (find-file
     (consult--read
      (-map (lambda (dir)
              (->> dir (zoxide-weighted-pair) (cadr) (abbreviate-file-name)))
            (zoxide-query-ls))
      :require-match t
      :category 'file
      :sort nil
      :prompt "zoxide: "
      )
     )
  )

(dwuggh/leader-def
  "fz" '(consult-z :wk "find directory with zoxide"))

(provide 'init-z)
