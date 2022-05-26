
(use-package conda
  :init
  (setq conda-anaconda-home "/opt/anaconda"
        conda-env-home-directory (expand-file-name "~/.conda/")
        )
  :config
  ;; (conda-env-autoactivate-mode 1)
  (conda-env-activate "env0")
  )

(use-package anaconda-mode
  :defer t
  :straight (anaconda-mode
             :type git
             :host github
             :repo "pythonic-emacs/anaconda-mode"
             :files ("*.el" "anaconda-mode.py"))
  :init
  (setq anaconda-mode-installation-directory (concat my-cache-dir "anaconda-mode"))
  ;; (add-hook 'python-mode-hook 'anaconda-eldoc-mode)
  ;; (add-hook 'python-mode-hook 'anaconda-mode)

  :config
  (defun anaconda-mode-show-doc-advice (result)
    "Show documentation view for rpc RESULT, and return buffer.
    Also enable markdown mode."
    (let ((buf (get-buffer-create "*Anaconda*")))
      (with-current-buffer buf
        (view-mode -1)
        (erase-buffer)
        (mapc
         (lambda (it)
           (insert (propertize (aref it 0) 'face 'bold))
           (insert "\n")
           (insert (s-trim-right (aref it 1)))
           (insert "\n\n"))
         result)
        (view-mode 1)
        (goto-char (point-min))
        (markdown-mode)
        (general-def
          :keymaps 'local
          "q" 'quit-window
          )
        buf)
      )
    )
  (advice-add 'anaconda-mode-documentation-view :override
              'anaconda-mode-show-doc-advice
              )
  )

(use-package company-anaconda
  :defer t
  :init
  (setq-mode-local python-mode company-backends
                   '((company-anaconda :with company-yasnippet)
                     company-capf
                     (company-dabbrev-code :with company-yasnippet)
                     company-yasnippet company-dabbrev))
  )

(defun anaconda-eldoc-toggle-posframe ()
  "Interactively toggle posframe view for documentation."
  (interactive)
  (if anaconda-mode-use-posframe-show-doc
      (setq anaconda-mode-use-posframe-show-doc nil)
    (setq anaconda-mode-use-posframe-show-doc t))
  )


(use-package lsp-pyright
  :config
  (defun lsp-pyright-hook ()
    (require 'lsp-pyright)
    (lsp)
    )
  (add-hook 'python-mode-hook #'lsp-pyright-hook)
  )

(general-def
   :definer 'minor-mode
   :keymaps 'anaconda-mode
   "K" 'anaconda-mode-show-doc
   )

(dwuggh/localleader-def
  :keymaps '(python-mode-map)
  :states '(normal visual)
  "sb" 'python-shell-send-buffer
  "sg" 'python-shell-send-file
  "sf" 'python-shell-send-defun
  "sr" 'python-shell-send-region
  )


(use-package ein
  :config
  (setq org-babel-load-languages
        (cons '(ein . t) org-babel-load-languages))
  )

(provide 'init-python)
