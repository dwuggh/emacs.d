


(use-package eaf
  :straight
  (eaf :type git :host github :repo "manateelazycat/emacs-application-framework"
       :files ("*.el" "*.py" "app" "core"))
  :custom
  (eaf-find-alternate-file-in-dired t)
  :config

  (setq eaf-evil-leader-key "SPC")
  ;; inherit general keymap in eaf
  (setq eaf-evil-leader-keymap
	(lookup-key
	 (general--get-keymap 'normal general-override-mode-map)
	 (kbd "SPC"))) 
  ;; `clear_focus' error, which is defined in a python file
  (ignore-errors (require 'eaf-evil))
  (eaf-bind-key take_photo "p" eaf-camera-keybinding)

  (setq eaf-proxy-type "socks5"
	eaf-proxy-host "127.0.0.1"
	eaf-proxy-port "1080")
  )

(require 's)

(defun my-eaf-open-buffer-pdf ()
  "open pdf with eaf pdfviewer."
  (interactive)
  (let* ((name (buffer-file-name))
	 (ext (file-name-extension name))
	 (pdf-name (s-append "pdf" (s-chop-suffix ext name))))
    (if (file-exists-p pdf-name)
	(progn
	  (when (= winum--window-count 1)
	    (call-interactively 'split-window-right)
	    (call-interactively 'evil-window-right))
	  (eaf-open pdf-name))
      (message (format "file not found: %s" pdf-name))))
  )


(dwuggh/localleader-def
 :keymaps '(latex-mode-map LaTeX-mode-map tex-mode-map)
 "v" 'my-eaf-open-buffer-pdf
 )


(provide 'init-eaf)
