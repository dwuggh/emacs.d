
(use-package sis
  :config
  ;; (sis-ism-lazyman-config nil "rime" 'native)
  (sis-ism-lazyman-config "1" "2" 'fcitx5)
    ;; enable the /cursor color/ mode
  (sis-global-cursor-color-mode t)
  ;; enable the /respect/ mode
  (sis-global-respect-mode t)
  ;; enable the /context/ mode for all buffers
  (sis-global-context-mode t)
  ;; enable the /inline english/ mode for all buffers
  (sis-global-inline-mode t)
  )


(use-package goldendict
  :defer t
  )

(defvar dw-command "dw -o auto --format md -t zh "
  "Command to run dw.")

(defvar dw-buffer-name "*dw-buffer*")

(define-derived-mode tempview-mode markdown-view-mode "temporary view"
  "Major mode for temporarily viewing markdown contents."
  (read-only-mode 1)
  (define-key tempview-mode-map "q" 'quit-window)
  (evil-define-key 'normal tempview-mode-map "q" 'quit-window)
  )

(defmacro dw-format-cmd (text)
  `(s-concat dw-command ,text)
  )

(defun dw-get (text)
  (interactive "Mword:")
  (let ((resp (shell-command-to-string (dw-format-cmd text)))
        )
    (when (called-interactively-p)
        (message resp))
    resp
    )
  )

(defun dw-req-buffer (text)
  (save-window-excursion
    (shell-command (dw-format-cmd text)
                   dw-buffer-name
                   "*dw-error*")
    )
  )


(defun region-or-word ()
  "Return word in region or word at point."
  (if (derived-mode-p 'pdf-view-mode)
      (if (pdf-view-active-region-p)
          (mapconcat 'identity (pdf-view-active-region-text) "\n"))
    (if (use-region-p)
        (buffer-substring-no-properties (region-beginning)
                                        (region-end))
      (thing-at-point 'word t))))


(defun dw-show-buffer-other-window ()
  (interactive)
  )

(defun dw-search-at-point ()
  (interactive)
  (dw-req-buffer (region-or-word))
  (with-current-buffer (get-buffer-create dw-buffer-name)
    (setq-local buffer-read-only t)
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      (tempview-mode)
      )
    )
  (switch-to-buffer-other-window dw-buffer-name)
  )

(defun dw-search-at-point-posframe ()
  (interactive)
  (dw-req-buffer (region-or-word))
  (with-current-buffer (get-buffer-create dw-buffer-name)
    (setq-local buffer-read-only t)
    (let ((inhibit-read-only t))
      (goto-char (point-min))
      (tempview-mode)
      )
    )
  (posframe-show dw-buffer-name
                 :left-fringe 8
                 :right-fringe 8
                 :internal-border-width 1
                 :internal-border-color (face-foreground 'default)
                 )
  (unwind-protect
      (push (read-event) unread-command-events)
    (progn
      (posframe-delete dw-buffer-name)
      (other-frame 0)))
  )





(dwuggh/leader-def
 "l" '(:ignore t :wk "language")
 "lg" '(goldendict-dwim :wk "goldendict")
 "la" '(dw-search-at-point-posframe :wk "dw at point posframe")
 "ld" '(dw-search-at-point :wk "dw at point")
 "ls" 'youdao-dictionary-search-async
 "lv" '(youdao-dictionary-play-voice-at-point :wk "youdao voice")
 )

(provide 'init-chinese)
