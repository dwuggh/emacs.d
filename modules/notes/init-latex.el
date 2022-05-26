
(defvar image-directory "./img/")
(defvar xclip-cmd "xclip -sel c -t image/png -o")

(defun paste-image ()
  "Paste image to directory"
  (interactive)
  (let ((img-dir-p (call-process-shell-command (s-concat "ls " image-directory))))
    (when (or (eql 0 img-dir-p)
              (when (y-or-n-p (format "create the image directory %s ?" image-directory))
                  (shell-command (s-concat "mkdir " image-directory)))
              )
      (store-image)
      )
    )
  )

(defun store-image ()
  (let* ((name (read-from-minibuffer "image file name: "))
         (name1 (s-concat image-directory
                          (if (s-ends-with? ".png" name)
                              (s-trim name)
                            (s-concat (s-trim name) ".png"))))
         )
    
    (if (not (eql 0 (async-shell-command (s-concat xclip-cmd " > " name1))))
        (user-error "no image in clipboard!")
      (message (format "successfully paste image %s" name1))
      name1
      )
    )
  )

(use-package tex
  ;; :straight (auctex :host github
  ;;                   :repo "emacsmirror/auctex"
  ;;                   ;; :files (:exclude "*.el.in")
  ;;            )
  :straight auctex
  ;; :defer t
  :init
  (setq
   TeX-command-default "latexmk"
   TeX-auto-save t
   TeX-parse-self t
   TeX-syntactic-comment t
   ;; Synctex support
   TeX-source-correlate-start-server nil
   ;; Don't insert line-break at inline math
   LaTeX-fill-break-at-separators nil
   )
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
  (add-hook 'LaTeX-mode-hook 'smartparens-mode)
  :config
  (define-key TeX-mode-map (kbd "$") nil)
  )

(use-package auctex-latexmk
  ;; :defer t
  :config
  )

(use-package lsp-latex
  :defer t
  :init
  (add-hook 'tex-mode-hook 'my-lsp-init)
  (add-hook 'latex-mode-hook 'my-lsp-init)
  (add-hook 'LaTeX-mode-hook 'my-lsp-init)
  )

(use-package company-auctex
  :defer t
  )


(use-package company-reftex
  :defer t
  )

(setq-mode-local latex-mode company-backends
         '((
            company-capf
            ;; company-auctex-macros
            ;; company-auctex-symbols
            ;; company-auctex-environments
            :with company-yasnippet)
           (company-reftex-labels company-reftex-citations :with company-yasnippet)
           (company-dabbrev company-files company-semantic :with company-yasnippet))
      )

(use-package magic-latex-buffer
  :defer t
  :init
  (setq magic-latex-enable-block-highlight t
        magic-latex-enable-suscript t
        magic-latex-enable-pretty-symbols t
        magic-latex-enable-block-align nil
        magic-latex-enable-inline-image nil)
  (add-hook 'TeX-update-style-hook 'magic-latex-buffer)
  )

(use-package cdlatex
  :defer t
  :config
  (add-hook 'cdlatex-mode-hook
            (lambda ()
              (define-key cdlatex-mode-map "`" nil)
              (define-key cdlatex-mode-map "$" nil)))
  (defun my/org-disable-yasnippet-in-latex-environment ()
    (setq-local yas-buffer-local-condition '(not (org-inside-LaTeX-fragment-p))))

  (add-hook 'org-mode-hook #'my/org-disable-yasnippet-in-latex-environment)
  (add-hook 'LaTeX-mode-hook
            '(lambda () (define-key LaTeX-mode-map (kbd "TAB") 'cdlatex-tab)))

  )


;; (add-hook 'LaTeX-mode-hook 'cdlatex-mode)
;; (add-hook 'tex-mode-hook 'cdlatex-mode)

;; (setq my-asymbol-dir (concat user-emacs-directory "lisp/asymbol"))
(straight-use-package `(asymbol :local-repo ,(concat user-emacs-directory "lisp/asymbol/")))

(use-package asymbol
  :init
  (setq asymbol-help-symbol-linewidth 80
    asymbol-help-tag-linewidth    80
    )
  (global-asymbol-mode 1)
  (add-hook 'org-mode-hook #'org-cdlatex-mode)
  (add-hook 'org-mode-hook #'asymbol-mode)
  (add-hook 'latex-mode-hook #'asymbol-mode)
  (add-hook 'LaTeX-mode-hook #'asymbol-mode)
  (add-hook 'tex-mode-hook #'asymbol-mode)
  (add-hook 'org-cdlatex-mode-hook
          (lambda () 
            (define-key org-cdlatex-mode-map
          "`" 'asymbol-insert-text-or-symbol)
            ;; (define-key cdlatex-mode-map
        ;;   "`" 'asymbol-insert-text-or-symbol)
        ))
  )

(use-package laas
  :defer t
  ;; :after org
  ;; :hook (org-mode . laas-mode)
  :init
  (add-hook 'org-mode-hook #'laas-mode)
  (add-hook 'latex-mode-hook #'laas-mode)
  (add-hook 'LaTeX-mode-hook #'laas-mode)
  (add-hook 'tex-mode-hook #'laas-mode)
  :config
  (setq laas-enable-auto-space nil)
  (aas-set-snippets 'laas-mode
                    :cond #'latex-environment-p
                    "tan" "\\tan"
                    ;; 内积
                    "sr" "^2"
                    "RR" "\\mathbb{R}"
                    "ZZ" "\\mathbb{Z}"
                    ;; 还可以绑定函数，和 yasnippet 联动
                    "Sum" (lambda () (interactive)
                            (yas-expand-snippet "\\sum_{$1}^{$2} $0"))
                    ;; 这是 laas 中定义的用于包裹式 latex 代码的函数，实现 \bm{a}
                    :cond #'laas-object-on-left-condition
                    ",." (lambda () (interactive) (laas-wrap-previous-object "bm"))
                    ".," (lambda () (interactive) (laas-wrap-previous-object "bm")))
  )

;;; https://github.com/karthink/lazytab
(advice-add 'orgtbl-ctrl-c-ctrl-c :after #'orgtbl-replace)
(defun orgtbl-replace (_unused)
  (interactive "P")
  (unless (org-at-table-p) (user-error "Not at a table"))
  (let* ((table (org-table-to-lisp))
         params
         (replacement-table
          (if (texmathp)
              (orgtbl-to-amsmath table params)
            (orgtbl-to-latex table params))))
    (kill-region (org-table-begin) (org-table-end))
    (open-line 1)
    (push-mark)
    (insert replacement-table)
    (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
    (orgtbl-mode -1)
    ;; (advice-remove 'orgtbl-ctrl-c-ctrl-c #'orgtbl-replace)
    ))

(defun orgtbl-to-amsmath (table params)
  (orgtbl-to-generic
   table
   (org-combine-plists
    '(:splice t
      :lstart ""
      :lend " \\\\"
      :sep " & "
      :hline nil
      :llend "")
    params)))


;;; useful functions
;;; -----------------------------------------------------------
(setq display-buffer-alist
      (cons `(,shell-command-buffer-name-async display-buffer-no-window)
        display-buffer-alist))

(setq display-buffer-alist
      (cons '("\\*easy-latex-compile-*" display-buffer-no-window)
        display-buffer-alist))

(defvar latex-easy-compile-cmd
  "tectonic %s"
  "command for `latex-easy-compile'"
  )
;; (setq latex-easy-compile-cmd "tectonic --keep-intermediates --print %s")
;; (setq latex-easy-compile-cmd "latexmk -cd -e \"\$pdflatex = 'pdflatex -interaction=nonstopmode -shell-escape -synctex=1 %%S %%O'\" %s -f -pdf")

;; (setq latex-easy-compile-cmd "latexmk -cd %s -f -pdf")
(setq latex-easy-compile-cmd "latexmk -cd %s -f -pdfxe")
(defun latex-easy-compile-switch-engine ()
  (interactive)
  (if (s-equals? latex-easy-compile-cmd "tectonic %s")
      (setq latex-easy-compile-cmd "xelatex -interaction nonstopmode -synctex=1 \"%s\"")
    (setq latex-easy-compile-cmd "tectonic %s")
      )
    )

(defun latex-easy-compile ()
  "compile .tex file easily"
  (interactive)
  (let* ((name (buffer-file-name))
         ;; (cmd (format "xelatex -interaction nonstopmode -synctex=1 \"%s\"" name))
         )
    (async-shell-command (format latex-easy-compile-cmd name)
                         "*easy-latex-compile-log*" "*easy-latex-compile-error*")
    ))

(dwuggh/localleader-def
 :keymaps '(latex-mode-map LaTeX-mode-map tex-mode-map)
 "c" 'latex-easy-compile
 )


(defvar-local company-latex--toggle-backend-state nil)
(defun company-latex-toggle-backend ()
  "Toggle between lsp backend and company-auctex."
  (interactive)
  (if company-latex--toggle-backend-state
    (setq-local company-backends company-latex--toggle-backend-state
                company-latex--toggle-backend-state nil)
      (setq-local company-latex--toggle-backend-state company-backends
                  company-backends
                  '((company-auctex-macros company-auctex-symbols company-auctex-environments :with company-yasnippet)
                    company-dabbrev)
      )
    )
  )


(provide 'init-latex)
