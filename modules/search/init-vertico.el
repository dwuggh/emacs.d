


(use-package savehist
  :ensure nil
  :init
  (setq savehist-file (concat my-cache-dir "history"))
  (savehist-mode)
  )

(use-package vertico
  :init
  (define-key minibuffer-mode-map (kbd "C-v") #'yank)
  (setq vertico-count 17
        vertico-cycle t
        )
  ;; https://emacs.stackexchange.com/questions/14755/how-to-remove-bindings-to-the-esc-prefix-key
  (define-key key-translation-map (kbd "ESC") (kbd "C-g"))
  (add-hook 'minibuffer-setup-hook #'vertico-repeat-save)
  ;; TODO this will blink
  ;; (add-hook 'minibuffer-setup-hook #'hide-mode-line-1)
  ;; (add-hook 'minibuffer-exit-hook #'hide-mode-line-0)
  :config
  ;; (define-key vertico-map "?" #'minibuffer-completion-help)
  (vertico-mode)
  (define-key vertico-map (kbd "M-RET") #'minibuffer-force-complete-and-exit)
  (define-key vertico-map (kbd "M-TAB") #'minibuffer-complete)
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous)
  ;; (define-key vertico-map (kbd "C-h") 'delete-backward-char)
  ;; (define-key vertico-map (kbd "C-h") nil)
  (custom-set-faces
   '(completions-common-part
     (( t :inherit ivy-minibuffer-match-face-1 )))
   '(vertico-current
     (( t :inherit ivy-prompt-match )))
   )
  (require 'better-find-file)
  (dwuggh/leader-def
    "fr" '(my-consult-recent-file :wk "find recent files")
    "ff" '(my-find-file :wk "find files in current dir")
    "fs" '(save-buffer :wk "save file")
    "fS" '(evil-write-all :wk "save all file")
    )
  
  )


(use-package marginalia
  :init
  (setq
   marginalia-field-width 80
   marginalia-align 'right
   )
  :config
  (marginalia-mode)
  )

(use-package consult
  :init
  (setq consult-async-min-input 2
        completion-ignore-case t
        consult-async-refresh-delay 0.1
        consult-async-split-style 'semicolon
        consult-async-input-throttle 0.1
        consult-async-input-debounce 0.1
        completion-in-region-function #'consult-completion-in-region
        consult-line-start-from-top nil
        consult--buffer-display #'switch-to-buffer
        consult-narrow-key "<"
        ;; otherwise `consult-line' would be too slow
        ;; https://github.com/minad/consult/issues/329
        consult-fontify-max-size 1024
        xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref
        )
  :config
  
  (setq consult-grep-args consult-ripgrep-args)
  (consult-customize
   consult-ripgrep
   :preview-key "C-l"
   )
  )
(use-package embark)

(use-package embark-consult
  :after (embark consult)
  :hook
  (embark-collect-mode . consult-preview-at-point-mode)
  :config
  (define-key vertico-map (kbd "C-\"") 'embark-act)
  (define-key vertico-map (kbd "C-/") 'embark-dwim)
  )

(use-package consult-flycheck
  :after (consult flycheck))


(use-package orderless
  :init
  (setq orderless-component-separator "[ &]")
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        ;; completion-category-overrides nil
        orderless-component-separator "[ &]"
        )
  (add-to-list 'completion-category-overrides '((file (styles . (orderless partial-completion)))))
  ;; otherwise find-file gets different highlighting than other commands
  (set-face-attribute 'completions-first-difference nil :inherit nil)
  )


(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config (setq wgrep-auto-save-buffer t))

(defun my-project-root ()
  (if (s-equals?
       (s-trim-right (shell-command-to-string "git rev-parse --is-inside-work-tree"))
       "true")
      (s-trim-right (shell-command-to-string "git rev-parse --show-toplevel"))
    (when-let (project (project-current)) (project-root project))
    ))


(setq consult-project-root-function 'my-project-root)

;;; form doom-emacs
(cl-defun my-consult-file-search (&key query in all-files (recursive t) prompt args)
  "Conduct a file search using ripgrep.
:query STRING
  Determines the initial input to search for.
:in PATH
  Sets what directory to base the search out of. Defaults to the current project's root.
:recursive BOOL
  Whether or not to search files recursively from the base directory."
  (declare (indent defun))
  (unless (executable-find "rg")
    (user-error "Couldn't find ripgrep in your PATH"))
  (require 'consult)
  (setq deactivate-mark t)
  (let* ((project-root (or (my-project-root) default-directory))
         (directory (or in project-root))
         (args
          (split-string
           (string-trim
            (concat (if all-files "-uu")
                    (unless recursive "--maxdepth 1")
                    "--null --line-buffered --color=always --max-columns=500 --no-heading --line-number"
                    " --hidden -g !.git "
                    (mapconcat #'shell-quote-argument args " ")))
           " "))
         (prompt (if (stringp prompt) (string-trim prompt) "Search"))
         (query (or query
                    ;; (when (doom-region-active-p)
                    ;;   (rxt-quote-pcre (doom-thing-at-point-or-region)))
                    ))
         (ripgrep-command (string-join `("rg" ,@args "." "-e ARG OPTS" ) " "))
         (consult-async-split-style consult-async-split-style)
         (consult-async-split-styles-alist consult-async-split-styles-alist))
    ;; Change the split style if the initial query contains the separator.
    (when query
      (cl-destructuring-bind (&key type separator initial)
          (consult--async-split-style)
        (pcase type
          (`separator
           (replace-regexp-in-string (regexp-quote (char-to-string separator))
                                     (concat "\\" (char-to-string separator))
                                     query t t))
          (`perl
           (when (string-match-p initial query)
             (setf (alist-get 'perlalt consult-async-split-styles-alist)
                   `(:initial ,(or (cl-loop for char in (list "%" "@" "!" "&" "/" ";")
                                            unless (string-match-p char query)
                                            return char)
                                   "%")
                              :type perl)
                   consult-async-split-style 'perlalt))))))
    (consult--grep prompt ripgrep-command directory query)))

(defun my-consult-project-search (&optional arg initial-query directory)
  "Peforms a live project search from the project root using ripgrep.
If ARG (universal argument), include all files, even hidden or compressed ones,
in the search."
  (interactive "P")
  (my-consult-file-search :query initial-query :in directory :all-files arg))

(defun my-consult-project-search-from-cwd (&optional arg initial-query)
  "Performs a live project search from the current directory.
If ARG (universal argument), include all files, even hidden or compressed ones."
  (interactive "P")
  (my-consult-project-search arg initial-query default-directory))


(defvar my-consult-find-file-in--history nil)
;;;###autoload
(defun my-consult-find-file-in (&optional dir initial)
  "Jump to file under DIR (recursive).
If INITIAL is non-nil, use as initial input."
  (interactive)
  (let* ((default-directory (or dir default-directory))
         (prompt-dir (consult--directory-prompt "Find" default-directory))
         (cmd (split-string-and-unquote consult-find-args " "))
         (cmd (remove "OPTS" cmd))
         (cmd (remove "ARG" cmd)))
    (find-file
     (consult--read
      (split-string (cdr (apply #'call-process cmd)) "\n" t)
      :prompt default-directory
      :sort nil
      :require-match t
      :initial (if initial (shell-quote-argument initial))
      :add-history (thing-at-point 'filename)
      :category 'consult
      :history '(:input my-consult-find-file-in--history))))
  )

(provide 'init-vertico)
