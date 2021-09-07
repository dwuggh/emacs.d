;;; -*- lexical-binding: t; -*-


;;; ivy, counsel, swiper


(use-package ivy
  :config
  ;; (ivy-mode 1)
  (setq enable-recursive-minibuffers t
        ivy-use-virtual-buffers nil
        ivy-dynamic-exhibit-delay-ms 0
        ivy-height 17
        )
  (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-h") 'ivy-backward-delete-char)
  ;; (evil-define-key 'normal ivy-occur-grep-mode-map "SPC fs" 'wgrep-finish-edit)
  ;; (general-def
  ;;   :major-modes 'ivy-occur-grep-mode
  ;;   :states '(normal visual motion)
  ;;   "SPC fs" 'save-buffer
  ;;   )
  )

(use-package swiper)

(use-package counsel
  :config
  ;; (general-define-key
  ;;  :keymaps 'override
  ;;  :prefix "C-h"
  ;;  "f" '(counsel-describe-function :wk "describe function")
  ;;  "v" '(counsel-describe-variable :wk "describe variable")
  ;;  "o" '(counsel-describe-symbol :wk "describe symbol")
  ;;  )
  )
(use-package prescient
  :init
  (setq
   prescient-save-file (expand-file-name (concat my-cache-dir "prescient-save.el"))
   )
  :config
  (prescient-persist-mode 1)
  )

(use-package ivy-prescient
  :init
  (setq ivy-prescient-retain-classic-highlighting t)
  :config
  (ivy-prescient-mode 1)
  )

;; from doom emacs
;; (defun +ivy-rich-describe-variable-transformer (cand)
;;   "Previews the value of the variable in the minibuffer"
;;   (let* ((sym (intern cand))
;;          (val (and (boundp sym) (symbol-value sym)))
;;          (print-level 3))
;;     (replace-regexp-in-string
;;      "[\n\t\^[\^M\^@\^G]" " "
;;      (cond ((booleanp val)
;;             (propertize (format "%s" val) 'face
;;                         (if (null val)
;;                             'font-lock-comment-face
;;                           'success)))
;;            ((symbolp val)
;;             (propertize (format "'%s" val)
;;                         'face 'highlight-quoted-symbol))
;;            ((keymapp val)
;;             (propertize "<keymap>" 'face 'font-lock-constant-face))
;;            ((listp val)
;;             (prin1-to-string val))
;;            ((stringp val)
;;             (propertize (format "%S" val) 'face 'font-lock-string-face))
;;            ((numberp val)
;;             (propertize (format "%s" val) 'face 'highlight-numbers-number))
;;            ((format "%s" val)))
;;      t)))

;; (use-package ivy-rich
;;   :config
;;   ;; (plist-put+ ivy-rich-display-transformers-list
;;   ;;             'counsel-describe-variable
;;   ;;             '(:columns
;;   ;;               ((counsel-describe-variable-transformer (:width 40)) ; the original transformer
;;   ;;                (+ivy-rich-describe-variable-transformer (:width 50)) ; display variable value
;;   ;;                (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
;;   ;;             'counsel-M-x
;;   ;;             '(:columns
;;   ;;               ((counsel-M-x-transformer (:width 60))
;;   ;;                (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
;;   ;;             ;; Apply switch buffer transformers to `counsel-projectile-switch-to-buffer' as well
;;   ;;             'counsel-projectile-switch-to-buffer
;;   ;;             (plist-get ivy-rich-display-transformers-list 'ivy-switch-buffer)
;;   ;;             'counsel-bookmark
;;   ;;             '(:columns
;;   ;;               ((ivy-rich-candidate (:width 0.5))
;;   ;;                (ivy-rich-bookmark-filename (:width 60)))))

;;   (ivy-rich-mode 1)
;;   (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
;;   )

;; (defun ivy-rich-switch-buffer-icon (candidate)
;;   (with-current-buffer
;;       (get-buffer candidate)
;;     (let ((icon (all-the-icons-icon-for-mode major-mode)))
;;       (if (symbolp icon)
;;           (all-the-icons-icon-for-mode 'fundamental-mode)
;;         icon))))


;; (use-package ivy-posframe
;;   :init
;;   (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
;;   (setq ivy-posframe-display-functions-alist
;;         '(
;;           ;; (swiper . ivy-display-function-fallback)
;;           (swiper . ivy-posframe-display-at-frame-bottom-window-center)
;;           (swiper-isearch . ivy-posframe-display-at-frame-bottom-window-center)
;;           (complete-symbol . ivy-posframe-display-at-point)
;;           (counsel-M-x . ivy-posframe-display-at-frame-center)
;;           (t . ivy-posframe-display-at-frame-center)))
;;   :config
;;   ;; (ivy-posframe-mode 1)
;;   )

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

(defun consult-line-thing-at-point ()
  "`consult-line' with initial input."
  (interactive)
  (consult-line (my-thing-at-point) t)
  )

(defun my-counsel-rg-thing-at-point ()
  "From `swiper-isearch-thing-at-point'"
  (interactive)
  (counsel-rg (my-thing-at-point) default-directory)
  )

(defun my-counsel-rg-dir ()
  "ripgrep in current directory"
  (interactive)
  (counsel-rg nil default-directory)
  )


(defun my-counsel-projectile-rg-thing-at-point ()
  "Search current project with tap."
  (interactive)
  (let ((counsel-projectile-rg-initial-input '(ivy-thing-at-point)))
    (counsel-projectile-rg)))

(dwuggh/leader-def
 "ss" '(consult-line :wk "consult line")
 "sS" '(swiper-thing-at-point :wk "swiper TAP")
 "s C-s" '(swiper-all-thing-at-point :wk "swiper all buffer TAP")
 "sg" '(consult-line-multi :wk "swiper all buffer")
 "sb" '(swiper-isearch :wk "swiper")
 "sd" '(consult-ripgrep :wk "search current directory")
 "si" 'consult-imenu
 "i" 'consult-imenu
 "so" 'consult-outline
 "sn" 'consult-focus-lines
 "sD" '(my-counsel-rg-thing-at-point :wk "search current directory TAP")
 "sp" '(counsel-projectile-rg :wk "rg project")
 "ps" '(counsel-projectile-rg :wk "rg project")
 "sP" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
 "pS" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
 "se" '(consult-flycheck :wk "flycheck errors")
 "'" '(ivy-resume :wk "last search")
 ";" '(vertico-repeat :wk "last search")
 )

(require 'init-jump)
(require 'init-vertico)
(require 'init-files)
(require 'init-projects)
(require 'init-buffer)

;;; helpful
;;; ------------------------------------------------------------------------------

(use-package helpful
  :straight (helpful :type git :host github :repo "Wilfred/helpful")
  :config
  (setq helpful-switch-buffer-function 'pop-to-buffer)
  (global-set-key (kbd "C-h k") 'helpful-key)
  ;; (general-def
  ;;   :state 'normal
  ;;   :keymaps 'helpful-mode-map
  ;;   "RET" 'helpful-visit-reference
  ;;  )
  (setq counsel-describe-function-function #'helpful-callable)
  (setq counsel-describe-variable-function #'helpful-variable)
  )


(defun zoxide-query-l ()
  (s-split "\n" (shell-command-to-string "zoxide query -l"))
  )

(defun zoxide-query-ls ()
  (-map 's-trim (s-split "\n" (shell-command-to-string "zoxide query -ls")))
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
;; (setq ivy-sort-functions-alist
;; '((counsel-minor . ivy-prescient-sort-function)
;;   (counsel-colors-web . ivy-prescient-sort-function)
;;   (counsel-unicode-char . ivy-prescient-sort-function)
;;   (counsel-register . ivy-prescient-sort-function)
;;   (counsel-mark-ring . ivy-prescient-sort-function)
;;   (counsel-file-register . ivy-prescient-sort-function)
;;   (counsel-describe-face . ivy-prescient-sort-function)
;;   (counsel-info-lookup-symbol . ivy-prescient-sort-function)
;;   (counsel-apropos . ivy-prescient-sort-function)
;;   (counsel-describe-symbol . ivy-prescient-sort-function)
;;   (read-file-name-internal . ivy-prescient-sort-function)
;;   (t . ivy-prescient-sort-function)))

(setq ivy-sort-functions-alist
      (cons '(counsel-z . ivy-zoxide-sort-function) ivy-sort-functions-alist))

(defun counsel-z ()
  "Counsel with zoxide."
  (interactive)
  (let ((dirs (zoxide-query-ls)))
    (ivy-read "switch to directory: "
              dirs
              :require-match t
              :caller 'counsel-z
              :action
              (lambda (dir)
                (->> dir
                  (zoxide-weighted-pair)
                  (cadr)
                  (find-file))))))

(provide 'init-search)
;;; init-search.el ends here
