;;; -*- lexical-binding: t; -*-


;;; use posframe for rime and company
(use-package posframe)


(defvar my-window-number-cache nil
  "window cache, for jumping")


(use-package popper
  :init
  (setq popper-reference-buffers
        '("\\*Messages\\*"
          "Output\\*$"
          "\\*Async Shell Command\\*"
          help-mode
          helpful-mode
          compilation-mode))
  (popper-mode +1)
  (popper-echo-mode +1)
  (define-key popper-mode-map (kbd "C-`") #'popper-cycle)
  (setq popper-group-function #'popper-group-by-project)
  )

(use-package winum
  :config
  (setq winum-auto-assign-0-to-minibuffer t
        winum-auto-setup-mode-line nil
        winum-ignored-buffers '(" *which-key*"))
  (winum-mode))



;; from https://gist.github.com/3402786
(defun spacemacs/toggle-maximize-buffer ()
  "Maximize buffer"
  (interactive)
  (save-excursion
    (if (and (= 1 (length (window-list)))
             (assoc ?_ register-alist))
        (jump-to-register ?_)
      (progn
        (window-configuration-to-register ?_)
        (delete-other-windows)))))



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
  "wd" '(evil-window-delete :wk "delete current window")
  "wm" '(spacemacs/toggle-maximize-buffer :wk "maximize window")
  "wM" 'ace-swap-window
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
