
(straight-use-package 'org)
(straight-use-package 'org-plus-contrib)

(use-package org-superstar
  :defer t
  :init (add-hook 'org-mode-hook 'org-superstar-mode))


(use-package evil-org)

(use-package org-roam
  :defer t
  :hook
  (after-init . org-roam-mode)
  :custom
  (org-roam-directory (expand-file-name "~/org/roam/"))
  :init
  ;; (progn
  ;;   (spacemacs/declare-prefix "ar" "org-roam")
  ;;   (spacemacs/set-leader-keys
  ;;    "arl" 'org-roam
  ;;    "art" 'org-roam-dailies-today
  ;;    "arf" 'org-roam-find-file
  ;;    "arg" 'org-roam-graph)

  ;;   (spacemacs/declare-prefix-for-mode 'org-mode "mr" "org-roam")
  ;;   (spacemacs/set-leader-keys-for-major-mode 'org-mode
  ;; 					      "rl" 'org-roam
  ;; 					      "rt" 'org-roam-dailies-today
  ;; 					      "rb" 'org-roam-switch-to-buffer
  ;; 					      "rf" 'org-roam-find-file
  ;; 					      "ri" 'org-roam-insert
  ;; 					      "rg" 'org-roam-graph))
  )

;;; latex editing
;;; ------------------------------------------------------------------------------------

;; auto preview latex fragments
(setq-default org-preview-latex-image-directory
	      (concat user-emacs-directory ".cache/ltximg/"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (latex . t)   ;; <== add latex to the list
   (python . t)
   (shell . t)
   ))

(setq-default org-latex-default-packages-alist
   '(("AUTO" "inputenc" t
      ("xelatex"))
     ("T1" "fontenc" t
      ("xelatex"))
     ("" "graphicx" t nil)
     ("" "longtable" nil nil)
     ("" "wrapfig" nil nil)
     ("" "rotating" nil nil)
     ("normalem" "ulem" t nil)
     ("" "amsmath" t nil)
     ("" "textcomp" t nil)
     ("" "amssymb" t nil)
     ("" "capt-of" nil nil)
     ("" "hyperref" nil nil)))

(setq-default org-latex-packages-alist
              '(
		("" "ctex" t nil)
                ("" "braket" t nil)
                ))


(add-hook 'org-mode-hook
  (lambda ()
    (interactive)
    (org-latex-preview '(16))
    ))



(straight-use-package '(org-edit-latex :local-repo "~/Projects/emacs/org-edit-latex/"))
(use-package org-edit-latex
  ;; :straight '(org-edit-latex :local-repo "~/Projects/emacs/org-edit-latex/")
  :defer t
  :init
  (setq org-edit-latex-default-frag-master
	(concat user-emacs-directory "frag-master.tex"))
  )

(require 'lib-hack)
;; configure latex preview
;; from doom emacs, auto refresh background with theme
(defun +org-refresh-latex-background-h (&rest args)
      "Previews are rendered with the incorrect background.
This forces it to read the background before rendering."
      (plist-put+ org-format-latex-options
                  :background
                  (face-attribute (if-let (remap (cadr (assq 'default face-remapping-alist)))
                                      (if (keywordp (car-safe remap))
                                          (plist-get remap :background)
                                        remap)
                                      'default)
                                  :background nil t)))

(plist-put+ org-format-latex-options
	    :scale 2.0
	    ;; :matchers
	    ;; (cons "\\\\begin\\\{.*\\\}")
	    )

(advice-add 'load-theme :after '+org-refresh-latex-background-h)

(add-hook 'org-mode-hook
	  '+org-refresh-latex-background-h)
;;; keybinding
;;; ------------------------------------------------------------------------------------


(dwuggh/leader-def
  "o" '(:ignore t :wk "org-mode")
  "ol" 'org-store-link
  "oi" 'org-insert-link

  "orl" 'org-roam
  "ort" 'org-roam-dailies-today
  "orf" 'org-roam-find-file
  "org" 'org-roam-graph
  )

(dwuggh/localleader-def
 :keymaps 'org-mode-map
 "'" 'org-edit-special
 "a" 'org-agenda
 "c" 'org-capture
 "v" 'org-latex-preview
 "d" '(:ignore t :wk "date")
 "dd" 'org-deadline
 "ds" 'org-schedule
 "dt" 'org-time-stamp
 "dT" 'org-time-stamp-inactive
 "tc" 'org-toggle-checkbox
 "te" 'org-toggle-pretty-entities
 "ti" 'org-toggle-inline-images
 "tl" 'org-toggle-link-display
 "tt" 'org-show-todo-tree
 "tT" 'org-todo
 "l" 'org-shiftright
 "h" 'org-shiftleft
 "j" 'org-shiftdown
 "k" 'org-shiftup
 )

(provide 'init-org)
