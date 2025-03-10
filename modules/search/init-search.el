;;; -*- lexical-binding: t; -*-


(defun my-thing-at-point ()
  "Thing at point."
  (cond
   ((use-region-p)
    (let ((thing
          (buffer-substring-no-properties
           (region-beginning) (region-end))))
      (goto-char (region-beginning))
      (deactivate-mark)
      thing))
   (t
    (let ((bnd (bounds-of-thing-at-point 'symbol)))
      (when (car bnd)
        (buffer-substring-no-properties (car bnd) (cdr bnd)))))))

(defun my-consult-line-thing-at-point ()
  "`consult-line' with initial input."
  (interactive)
  (consult-line (my-thing-at-point) t)
  )

(defun my-consult-rg-thing-at-point (&optional dir)
  "`consult-line' with initial input."
  (interactive "P")
  (consult-ripgrep dir (my-thing-at-point)))

(defun my-consult-grep-thing-at-point (&optional dir)
  "`consult-line' with initial input."
  (interactive "P")
  (consult-grep dir (my-thing-at-point))
  )

(defun my-consult-rg-dir (&optional input)
  "ripgrep in current directory"
  (interactive "P")
  (consult-ripgrep default-directory input)
  )

(defun my-consult-rg-dir-thing-at-point ()
  "ripgrep in current directory"
  (interactive)
  (consult-ripgrep default-directory (my-thing-at-point))
  )

(dwuggh/leader-def
 "ss" '(consult-line :wk "consult line")
 "sS" '(my-consult-line-thing-at-point :wk "swiper TAP")
 "sg" '(consult-line-multi :wk "swiper all buffer")
 "sd" '(my-consult-rg-dir :wk "search current directory")
 "sD" '(my-consult-rg-dir-thing-at-point :wk "search current directory TAP")
 "si" 'consult-imenu
 "i" 'consult-imenu
 "so" 'consult-outline
 "sn" 'consult-focus-lines
 "sp" '(consult-ripgrep :wk "rg project")
 "sP" '(my-consult-rg-thing-at-point :wk "rg project")
 "ps" '(consult-ripgrep :wk "rg project")
 ";" '(vertico-repeat :wk "last search")
 )

(general-define-key
 :states '(normal visual)
 :keymaps 'override
 "C-h A" 'describe-face
 )

(require 'init-jump)
(require 'init-vertico)
(require 'init-files)
(require 'init-projects)
(require 'init-buffer)
(require 'init-z)


(provide 'init-search)
;;; init-search.el ends here
