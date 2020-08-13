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
  )

(use-package auctex-latexmk
  :defer t
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
  (define-key
    cdlatex-mode-map
    (vector asymbol-trigger-key)
    'asymbol-insert-text-or-symbol)
  (add-hook 'org-cdlatex-mode-hook
            (lambda () (interactive)
              (define-key org-cdlatex-mode-map
		(vector asymbol-trigger-key)
	      'asymbol-insert-text-or-symbol)))
  )

(add-hook 'org-mode-hook 'turn-on-org-cdlatex)
(add-hook 'LaTeX-mode-hook 'cdlatex-mode)
(add-hook 'tex-mode-hook 'cdlatex-mode)

;; (setq my-asymbol-dir (concat user-emacs-directory "lisp/asymbol"))
(straight-use-package `(asymbol :local-repo ,(concat user-emacs-directory "lisp/asymbol/")))
(use-package asymbol
  :init
  (setq asymbol-help-symbol-linewidth 80
	asymbol-help-tag-linewidth    80
	)
  :config
  (general-def
    :keymaps 'override
    :states 'insert
    "C-`" (lambda () (interactive) (asymbol-insert-text-or-symbol 'symbol))
    )
  (asymbol-latex-input-symbol-on)
  (asymbol-org-input-symbol-on)
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
	)
    ;; (LaTeX-math-mode -1)
    ;; (TeX-source-correlate-mode -1)
    ;; (TeX-PDF-mode -1)
    (magic-latex-buffer -1)
    )
  )

(add-hook+ (latex-mode-hook LaTeX-mode-hook tex-mode-hook)
	   my-latex-mode)


(provide 'init-latex)
