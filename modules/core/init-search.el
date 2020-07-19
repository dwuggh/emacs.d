;;; -*- lexical-binding: t; -*-


(use-package ivy
  :config
  (ivy-mode 1)
  (setq enable-recursive-minibuffers t
        ivy-use-virtual-buffers t)
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
   )
  ;; (global-set-key (kbd "M-x") 'counsel-M-x)
  ;; (global-set-key (kbd "C-h f") 'counsel-describe-function)
  (global-set-key (kbd "C-h v") 'counsel-describe-variable)
  (global-set-key (kbd "C-h o") 'counsel-describe-symbol)
  )
(use-package swiper)

(use-package helpful
  :straight (helpful :type git :host github :repo "Wilfred/helpful")
  :config
  (global-set-key (kbd "C-h k") 'helpful-key))

(dwuggh/leader-def
 "ss" '(swiper-isearch :wk "tidy swiper")
 "sS" '(swiper-isearch-thing-at-point :wk "swiper TAP")
 "s C-s" '(swiper-all-thing-at-point :wk "swiper all buffer TAP")
 "sb" '(swiper :wk "swiper")

 )

(provide 'init-search)
;;; init-search.el ends here
