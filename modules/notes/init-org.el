(require 'lib-hack)

;; https://github.com/raxod502/straight.el/issues/211#issuecomment-355840069
;; (use-package git
;;   :defer t)

;; (defun org-git-version ()
;;   (let ((git-repo
;;      (f-join user-emacs-directory "straight/repos/org")))
;;     (s-trim (git-run "describe"
;;              "--match=release\*"
;;              "--abbrev=6"
;;              "HEAD"))))

;; (defun org-release ()
;;   (let ((git-repo
;;      (f-join user-emacs-directory "straight/repos/org")))
;;     (s-trim (s-chop-prefix "release_"
;;                (git-run "describe"
;;                     "--match=release\*"
;;                     "--abbrev=0"
;;                     "HEAD")))))

;; overlay support
;; ----------------------------------------------------------------------------------------

(use-package ov)

;; https://kitchingroup.cheme.cmu.edu/blog/2016/11/06/Justifying-LaTeX-preview-fragments-in-org-mode/
;; https://github.com/jkitchin/scimax/blob/50e06f88299249a556825549818a8f79cba867e8/scimax-org.el#L585-L616

;;;###autoload
(defun org-latex-fragment-justify (justification)
  "Justify the latex fragment at point with JUSTIFICATION.
JUSTIFICATION is a symbol for 'left, 'center or 'right."
  (interactive
   (list (intern-soft
          (completing-read "Justification (left): " '(left center right)
                           nil t nil nil 'left))))

  (let* ((ov (ov-at))
     (beg (ov-beg ov))
     (end (ov-end ov))
     (shift (- beg (line-beginning-position)))
     (img (overlay-get ov 'display))
     (img (and (and img (consp img) (eq (car img) 'image)
            (image-type-available-p (plist-get (cdr img) :type)))
           img))
     space-left offset)
    (when (and img (= beg (line-beginning-position)))
      (setq
       ;; space-left (- (window-max-chars-per-line) (car (image-display-size img)))
       space-left (- 80 (car (image-display-size img)))
       offset (floor (cond
              ((eq justification 'center)
               (- (/ space-left 2) shift))
              ((eq justification 'right)
               (- space-left shift))
              (t
               0))))
      (when (>= offset 0)
    (overlay-put ov 'before-string (make-string offset ?\ ))))))



(straight-use-package '(org :local-repo nil))
(straight-use-package '(org-plus-contrib :local-repo nil))


(use-package org
  :defer t
  :init
  (setq org-src-window-setup 'split-window-below
        org-hide-emphasis-markers nil
        )
  (setq-default org-latex-packages-alist
                '(
                  ("" "ctex" t nil)
                  ("" "braket" t nil)
                  ("" "tikz" t nil)
                  ("" "esint" t nil)
                  ))
  (setq-default org-format-latex-header
                (s-concat org-format-latex-header
                          "
\\usepackage[thinc]{esdiff}
\\newcommand*{\\dif}{\\mathop{}\\!\\mathrm{d}}"))

  (setq-default org-preview-latex-image-directory
                (concat user-emacs-directory ".cache/ltximg/"))
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
  (setq-default org-preview-latex-default-process 'dvipng)

  :config
  (defun org-latex-fragment-justify-advice (beg end image &optional imagetype)
    "After advice function to justify fragments."
    (org-latex-fragment-justify 'center))
  (defun org-latex-preview-hook ()
    "hook for auto `org-latex-preview'"
    (when org-mode-hook
      (when (and (not (equal (buffer-name) "*Youdao Dictionary*")))
        (org-latex-preview '(16))))
    )
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
              ;; specify the justification you want
              ;; :justify 'center
              )
  (advice-add 'org--make-preview-overlay :after 'org-latex-fragment-justify-advice)
  (advice-add 'load-theme :after '+org-refresh-latex-background-h)
  (add-hook 'org-mode-hook #'electric-pair-local-mode)
  (add-hook 'org-mode-hook #'org-latex-preview-hook)
  (add-hook 'org-mode-hook #'+org-refresh-latex-background-h)
  (defun org-toggle-emphasis-markers ()
    "Toggle markup display."
    (interactive)
    (if org-hide-emphasis-markers
        (setq org-hide-emphasis-markers nil)
      (setq org-hide-emphasis-markers t))
    (font-lock-flush)
    )

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (latex . t)   ;; <== add latex to the list
     (python . t)
     (shell . t)
     ))
  )


;; (defun my-org-mode-hook ()
;;   (add-hook 'completion-at-point-functions 'pcomplete-completions-at-point nil t))
;; (add-hook 'org-mode-hook #'my-org-mode-hook)

(use-package org-superstar
  :after org
  :init (add-hook 'org-mode-hook 'org-superstar-mode)
  )

(setq org-id-locations-file (concat my-cache-dir ".org-id-locations"))

(use-package evil-org
  :after org
  :init
  (add-hook 'org-mode-hook 'evil-org-mode)
  )


;; better table alignment
;; TODO integration with org-latex-preview
(use-package valign
  :straight (valign :host github
                    :repo "casouri/valign"
                    )
  :defer t
  :init
  (setq
   valign-fancy-bar t
   )
  (add-hook 'org-mode-hook #'valign-mode))


;;; latex editing
;;; ------------------------------------------------------------------------------------

;; auto preview latex fragments
;; set pdflatex to xelatex

;; customize packages

;; (straight-use-package '(my-org-edit-latex :local-repo "~/Projects/emacs/org-edit-latex/"))
(use-package my-org-edit-latex
  :straight (my-org-edit-latex :local-repo "~/Projects/emacs/org-edit-latex/")
  :after org
  :init
  (setq org-edit-latex-default-frag-master
    (concat user-emacs-directory "frag-master.tex"))
  (add-hook 'org-mode-hook #'org-edit-latex-mode)
  )


(use-package org-ml
  :after org
  :straight (org-ml :type built-in
                    :local-repo (concat user-emacs-directory "lisp/")
                    :files ("org-ml.el"))
  :init
  (add-hook 'org-mode-hook 'org-ml-mode)
  )

(use-package company-org-latex
  :after org
  :straight (company-org-latex :type built-in
                               :local-repo (concat user-emacs-directory "lisp/")
                               :files ("company-org-latex.el"))
  :init
  (defun org-setup-company ()
    (setq-local company-backends '(company-capf company-yasnippet company-dabbrev))
    (add-hook 'completion-at-point-functions #'org-latex-capf nil t)
    )
  (add-hook 'org-mode-hook 'org-setup-company)
  )

(defun latex-environment-p ()
  (or
   (and (or
         (equal major-mode 'latex-mode)
         (equal major-mode 'LaTeX-mode)
         (equal major-mode 'tex-mode)
         )
        (texmathp)
        )
   (and (equal major-mode 'org-mode)
        (org-inside-latex-environment-p))
   )
  )


;;; keybinding
;;; ------------------------------------------------------------------------------------


(dwuggh/leader-def
  "o" '(:ignore t :wk "org-mode")
  "ol" 'org-store-link
  "oi" 'org-insert-link

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
 "i" 'org-id-get-create
 )

(general-def
  :states '(normal visual motion)
  :keymaps 'org-src-mode-map
  ",," 'org-edit-src-exit
  ",k" 'org-edit-src-abort)


(use-package markdown-mode
  :defer t
  :init
  (setq markdown-hide-markup t
        markdown-hide-markup-in-view-modes t
        markdown-command "marked"
        )
  ;; (add-to-list 'auto-mode-alist '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . gfm-mode))
  :config
  (dwuggh/localleader-def
   :keymaps 'markdown-mode-map
   "tt" 'markdown-toggle-markup-hiding
   "tp" 'markdown-toggle-inline-images
   "tm" 'markdown-toggle-math
   )
  (general-def
    :states '(normal visual)
   :keymaps 'markdown-mode-map
   "TAB" 'markdown-cycle
    )
  )

(provide 'init-org)
