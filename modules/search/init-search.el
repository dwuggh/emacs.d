;;; -*- lexical-binding: t; -*-


;;; ivy, counsel, swiper


(use-package ivy
  :config
  (ivy-mode 1)
  (setq enable-recursive-minibuffers t
        ivy-use-virtual-buffers nil
	ivy-height 17
        )
  (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-h") 'ivy-backward-delete-char)
  )

(use-package swiper)

(use-package counsel
  :config
  (general-define-key
   :keymaps 'override
   "M-x" 'counsel-M-x
   :prefix "C-h"
   "f" '(counsel-describe-function :wk "describe function")
   "v" '(counsel-describe-variable :wk "describe variable")
   "o" '(counsel-describe-symbol :wk "describe symbol")
   )
  )

;; from doom emacs
(defun +ivy-rich-describe-variable-transformer (cand)
  "Previews the value of the variable in the minibuffer"
  (let* ((sym (intern cand))
         (val (and (boundp sym) (symbol-value sym)))
         (print-level 3))
    (replace-regexp-in-string
     "[\n\t\^[\^M\^@\^G]" " "
     (cond ((booleanp val)
            (propertize (format "%s" val) 'face
                        (if (null val)
                            'font-lock-comment-face
                          'success)))
           ((symbolp val)
            (propertize (format "'%s" val)
                        'face 'highlight-quoted-symbol))
           ((keymapp val)
            (propertize "<keymap>" 'face 'font-lock-constant-face))
           ((listp val)
            (prin1-to-string val))
           ((stringp val)
            (propertize (format "%S" val) 'face 'font-lock-string-face))
           ((numberp val)
            (propertize (format "%s" val) 'face 'highlight-numbers-number))
           ((format "%s" val)))
     t)))

(use-package ivy-rich
  :config
  (plist-put+ ivy-rich-display-transformers-list
              'counsel-describe-variable
              '(:columns
                ((counsel-describe-variable-transformer (:width 40)) ; the original transformer
                 (+ivy-rich-describe-variable-transformer (:width 50)) ; display variable value
                 (ivy-rich-counsel-variable-docstring (:face font-lock-doc-face))))
              'counsel-M-x
              '(:columns
                ((counsel-M-x-transformer (:width 60))
                 (ivy-rich-counsel-function-docstring (:face font-lock-doc-face))))
              ;; Apply switch buffer transformers to `counsel-projectile-switch-to-buffer' as well
              'counsel-projectile-switch-to-buffer
              (plist-get ivy-rich-display-transformers-list 'ivy-switch-buffer)
              'counsel-bookmark
              '(:columns
                ((ivy-rich-candidate (:width 0.5))
                 (ivy-rich-bookmark-filename (:width 60)))))

  (ivy-rich-mode 1)
  (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
  )

(defun ivy-rich-switch-buffer-icon (candidate)
  (with-current-buffer
      (get-buffer candidate)
    (let ((icon (all-the-icons-icon-for-mode major-mode)))
      (if (symbolp icon)
          (all-the-icons-icon-for-mode 'fundamental-mode)
        icon))))


;; (setq ivy-rich-display-transformers-list
;;       '(ivy-switch-buffer
;;         (:columns
;;          ((ivy-rich-switch-buffer-icon (:width 2))
;;           (ivy-rich-candidate (:width 30))
;;           (ivy-rich-switch-buffer-size (:width 7))
;;           (ivy-rich-switch-buffer-indicators (:width 4 :face error :align right))
;;           (ivy-rich-switch-buffer-major-mode (:width 12 :face warning))
;;           (ivy-rich-switch-buffer-project (:width 15 :face success))
;;           (ivy-rich-switch-buffer-path (:width (lambda (x) (ivy-rich-switch-buffer-shorten-path x (ivy-rich-minibuffer-width 0.3))))))
;;          :predicate
;;          (lambda (cand) (get-buffer cand)))))

(use-package ivy-posframe
  :init
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  (setq ivy-posframe-display-functions-alist
	'((swiper . ivy-display-function-fallback)
	  (swiper-isearch . ivy-display-function-fallback)
          (complete-symbol . ivy-posframe-display-at-point)
          (counsel-M-x . ivy-posframe-display-at-frame-center)
          (t . ivy-posframe-display-at-frame-center)))
  :config
  ;; (ivy-posframe-mode 1)
  )

(defun my-thing-at-point ()
  "Thing at point"
  (let (thing)
    (if (use-region-p)
        (progn
          (setq thing (buffer-substring-no-properties
                       (region-beginning) (region-end)))
          (goto-char (region-beginning))
          (deactivate-mark))
      (let ((bnd (bounds-of-thing-at-point 'symbol)))
        (when bnd
          (goto-char (car bnd)))
        (setq thing (ivy-thing-at-point))))
    thing)
  )

(defun my-counsel-rg-thing-at-point ()
  "From `swiper-isearch-thing-at-point'"
  (interactive)
  (counsel-rg (my-thing-at-point) default-directory)
  )

(defun my-counsel-projectile-rg-thing-at-point ()
  "Search current project with tap."
  (interactive)
  (let ((counsel-projectile-rg-initial-input '(ivy-thing-at-point)))
    (counsel-projectile-rg)))

(dwuggh/leader-def
 "ss" '(swiper :wk "swiper")
 "sS" '(swiper-thing-at-point :wk "swiper TAP")
 "s C-s" '(swiper-all-thing-at-point :wk "swiper all buffer TAP")
 "sb" '(swiper-isearch :wk "swiper")
 "sd" 'counsel-rg
 "sD" '(my-counsel-rg-thing-at-point :wk "rg at point")
 "sp" '(counsel-projectile-rg :wk "rg project")
 "ps" '(counsel-projectile-rg :wk "rg project")
 "sP" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
 "pS" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
 "'" '(ivy-resume :wk "last search")
 )

(require 'init-jump)
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


(use-package popwin
  :init
  (popwin-mode 1)
  (push
   '(helpful-mode :dedicated t :position bottom :stick t :noselect t :height 0.4)
   popwin:special-display-config))

(provide 'init-search)
;;; init-search.el ends here
