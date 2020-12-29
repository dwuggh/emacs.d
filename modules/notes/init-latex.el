;; (require 'tex)
;; typo

;; (use-package tex-site
;;   :straight (auctex :host github
;;                     :repo "emacsmirror/auctex"
;;                     :files (:default (:exclude "*.el.in"))
;; 		    )
;;   )
(use-package tex
  ;; :straight (auctex :host github
  ;;                   :repo "emacsmirror/auctex"
  ;;                   ;; :files (:exclude "*.el.in")
  ;; 		    )
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
  (add-hook 'tex-mode-hook 'lsp)
  (add-hook 'latex-mode-hook 'lsp)
  (add-hook 'LaTeX-mode-hook 'lsp)
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


(define-minor-mode my-latex-mode
  "My latex minor mode, easier for configuration."
  :keymap (let ((map (make-sparse-keymap)))
	    map)
  :init-value nil
  :global nil
  (if my-latex-mode
      (progn
	;; (LaTeX-math-mode 1)
	;; (TeX-source-correlate-mode 1)
	;; (TeX-PDF-mode 1)
	(magic-latex-buffer 1)
	;; (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
	(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
	(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
	(advice-add 'evil-escape-func :after 'jit-lock-refontify)
	(advice-add 'self-insert-command :after 'jit-lock-refontify)
	;; (advice-remove 'self-insert-command 'jit-lock-refontify)
	)
    ;; (LaTeX-math-mode -1)
    ;; (TeX-source-correlate-mode -1)
    ;; (TeX-PDF-mode -1)
    (magic-latex-buffer -1)
    (advice-remove 'evil-escape-func 'jit-lock-refontify)
    )
  )

;; (add-hook+ (latex-mode-hook LaTeX-mode-hook tex-mode-hook)
;; 	   my-latex-mode)

;;; useful functions
;;; -----------------------------------------------------------
(setq display-buffer-alist
      (cons `(,shell-command-buffer-name-async display-buffer-no-window)
	    display-buffer-alist))

(setq display-buffer-alist
      (cons '("\\*easy-latex-compile-*" display-buffer-no-window)
	    display-buffer-alist))

(defun latex-easy-compile ()
  "compile .tex file easily"
  (interactive)
  (let* ((name (buffer-file-name))
	 (cmd (format "xelatex -interaction nonstopmode -synctex=1 \"%s\"" name)))
    (async-shell-command cmd "*easy-latex-compile-log*" "*easy-latex-compile-error*")
    ))

(dwuggh/localleader-def
 :keymaps '(latex-mode-map LaTeX-mode-map tex-mode-map)
 "c" 'latex-easy-compile
 )

(provide 'init-latex)
