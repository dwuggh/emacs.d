;;; -*- lexical-binding: t; -*-

;;; use posframe for rime and company
(use-package posframe)


(defvar my-window-cache nil
  "window cache, for jumping")

(use-package popwin
  :init
  (popwin-mode 1)
  (push
   '(helpful-mode :dedicated t :position bottom :stick t :noselect t :height 0.4)
   popwin:special-display-config))

(defun my-popwin-display-buffer-advice (&rest args)
  (let ((window (selected-window)))
    (unless (equal window popwin:popup-window)
      (setq my-window-cache window))))

(advice-add 'popwin:display-buffer :before 'my-popwin-display-buffer-advice)

(use-package winum
  :config
  (setq winum-auto-assign-0-to-minibuffer t
        winum-auto-setup-mode-line nil
        winum-ignored-buffers '(" *which-key*"))
  (winum-mode))




;; FIXME report upstream?
;; prevent `display-buffer' from moving popwin buffer
(defun my-display-buffer-around (orig-fun buffer-or-name &optional action frame)
  "pre advice"
  (unless (equal (window-normalize-buffer buffer-or-name)
	     popwin:popup-buffer)
      (funcall orig-fun buffer-or-name action frame)))

(advice-add 'display-buffer :around 'my-display-buffer-around)


(dwuggh/leader-def
 "1" '(winum-select-window-1 :wk nil)
 "2" '(winum-select-window-2 :wk nil)
 "3" '(winum-select-window-3 :wk nil)
 "4" '(winum-select-window-4 :wk nil)
 "5" '(winum-select-window-5 :wk nil)
 "6" '(winum-select-window-6 :wk nil)
 "7" '(winum-select-window-7 :wk nil)
 "8" '(winum-select-window-8 :wk nil)
 "9" '(winum-select-window-9 :wk nil)
 "1..9" '(:ignore t :wk "select window 1..9")

 "wh" '(evil-window-left :wk "to leftward window")
 "wl" '(evil-window-right :wk "to rightward window")
 "wk" '(evil-window-up :wk "to upward window")
 "wj" '(evil-window-down :wk "to downward window")
 "w/" '(split-window-right :wk "vsplit")
 "w-" '(split-window-below :wk "vsplit")
 "w=" '(balance-windows-area :wk "balance windows")
 )

;; from spacemacs
;; Rename the entry for M-1 in the SPC h k Top-level bindings,
;; and for 1 in the SPC- Spacemacs root, to 1..9
(push '(("\\(.*\\)1" . "winum-select-window-1") .
        ("\\11..9" . "select window 1..9"))
      which-key-replacement-alist)

;; Hide the entries for M-[2-9] in the SPC h k Top-level bindings,
;; and for [2-9] in the SPC- Spacemacs root
(push '((nil . "winum-select-window-[2-9]") . t)
      which-key-replacement-alist)


(provide 'init-window)
;;; init-window.el ends here
