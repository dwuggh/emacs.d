
(use-package haskell-mode
  :defer t
  :config
  (defun haskell-compile-and-run ()
    "Compile and run current .hs file."
    (interactive)
    (haskell-compile "")
    )
  )

(use-package yaml-mode
  :defer t)

(provide 'init-haskell)
