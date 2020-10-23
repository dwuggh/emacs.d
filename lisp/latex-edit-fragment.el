;;; latexedit-fragment.el --- LaTeX math fragments editing helper -*- lexical-binding: t; -*-

;; Author: dwuggh <dwuggh@gmail.com>
;; URL:
;; Keywords: LaTeX, math
;; Version: 0.0.1
;; Package-Requires: ((emacs "24.4") (auctex "11.90"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

(require 'async)

(defcustom latex-edit-fragment-TeX-master
  ;; (expand-file-name "./frag-master.tex")
  (expand-file-name "~/.emacs.d/frag-master.tex")
  "Decide which frag-master.tex file to be used.
This package provides a default frag-master.tex. "
  :type 'string
  :group 'latex-edit-fragment
  )

(defcustom latex-edit-fragment-compile-command "latexmk %s")

(defun latex-edit-fragment-create-buffer ()
  "Create buffer for fragment edition"
  (interactive)
  (let ((buffer (create-file-buffer "/tmp/test.tex"))))
  (copy-file latex-edit-fragment-TeX-master "/tmp/test.tex")
  (find-file "/tmp/test.tex")
  )

(defun latex-edit-fragment-compile ()
  "compile"
  (interactive)
  (shell-command (format "xelatex %s -interaction=nonstopmode" "/tmp/test.tex"))
  )

(define-minor-mode latex-edit-fragment-mode
  "LaTeX fragment editting mode."
  :lighter "l"
  (let ((old-tex-master TeX-master))
    (if latex-edit-fragment-mode
	(progn
	  (setq-local TeX-master latex-edit-fragment-TeX-master)
	  )
      (setq-local TeX-master old-tex-master)
      )
    )
  )


(provide 'latex-edit-fragment)
;;; latex-edit-fragment.el ends here
