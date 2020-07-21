;;; -*- lexical-binding: t; -*-




(use-package ivy
  :config
  (ivy-mode 1)
  (setq enable-recursive-minibuffers t
        ivy-use-virtual-buffers nil
        )
  (define-key ivy-minibuffer-map (kbd "C-j") 'ivy-next-line)
  (define-key ivy-minibuffer-map (kbd "C-k") 'ivy-previous-line)
  (define-key ivy-minibuffer-map (kbd "C-h") 'ivy-backward-delete-char)
  )
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

(use-package swiper
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
  (counsel-projectile-rg (my-thing-at-point)))

(dwuggh/leader-def
 "ss" '(swiper-isearch :wk "tidy swiper")
 "sS" '(swiper-isearch-thing-at-point :wk "swiper TAP")
 "s C-s" '(swiper-all-thing-at-point :wk "swiper all buffer TAP")
 "sb" '(swiper :wk "swiper")
 "sd" 'counsel-rg
 "sD" '(my-counsel-rg-thing-at-point :wk "rg at point")
 "sp" '(counsel-projectile-rg :wk "rg project")
 "ps" '(counsel-projectile-rg :wk "rg project")
 "sP" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
 "pS" '(my-counsel-projectile-rg-thing-at-point :wk "rg project")
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
