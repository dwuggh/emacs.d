;;; latex-ts-mode.el --- tree-sitter support for LaTeX  -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:

(require 'treesit)

(declare-function treesit-parser-create "treesit.c")
(declare-function treesit-induce-sparse-tree "treesit.c")
(declare-function treesit-node-child "treesit.c")
(declare-function treesit-node-child-by-field-name "treesit.c")
(declare-function treesit-node-start "treesit.c")
(declare-function treesit-node-end "treesit.c")
(declare-function treesit-node-type "treesit.c")
(declare-function treesit-node-parent "treesit.c")
(declare-function treesit-query-compile "treesit.c")

;; NOTE see something like `rust-ts-mode--font-lock-settings', treesit directly
;; encode these queries(.scm files) into emacs lisp using `treesit-font-lock-rules'.
;; FEATURE is in `treesit-font-lock-feature-list'
;; (defun treesit-hl--highlight-region (beg end &optional loudly)
;;   "Highlight the region (BEG . END).
;; This is intended to be used as a buffer-local override of
;; `font-lock-fontify-region-function'.
;; See also `treesit-font-lock-fontify-region'.

;; If LOUDLY is non-nil, print debug messages."

;;   ;; step 1: extend the region
;;   (save-excursion
;;     )
;;   (let ((root-node (treesit-buffer-root-node)))
;;     )
;;   )

(defface latex-ts-mode-face-markup.link
  '((default :inherit font-lock-doc-markup-face)) "")
(defface latex-ts-mode-face-markup.environment
  '((default :inherit font-lock-keyword-face)) "")
(defface latex-ts-mode-face-markup.environment.name
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-keyword.directive
  '((default :inherit font-lock-keyword-face)) "")
(defface latex-ts-mode-face-variable.parameter
  '((default :inherit font-lock-variable-use-face)) "")
(defface latex-ts-mode-face-function
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-function.macro
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-module
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-markup.heading.1
  '((default :inherit font-lock-function-name-face :height 2.0)) "")
(defface latex-ts-mode-face-markup.heading.2
  '((default :inherit font-lock-function-name-face :height 1.5)) "")
(defface latex-ts-mode-face-markup.heading.3
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-markup.heading.4
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-markup.heading.5
  '((default :inherit font-lock-function-name-face)) "")
(defface latex-ts-mode-face-markup.heading.6
  '((default :inherit font-lock-function-name-face)) "")


(defvar-local latex-ts-mode--pos nil)
(defvar-local latex-ts-mode--pos-last nil)
(defvar-local latex-ts-mode--last-start nil)
(defvar-local latex-ts-mode--last-end nil)

(defcustom latex-ts-mode-show-markup-delay 0.2
  "Time delay for showing markup.")

(defvar-local latex-ts-mode-loudly nil
  "Show debug informations.")

(defun latex-ts-mode--set-curly-group-visibility (node v)
  (if (string-equal "curly_group" (treesit-node-type node))
      (let ((bra (treesit-node-child node 0))
            (ket (treesit-node-child node -1)))
        (put-text-property (treesit-node-start bra) (treesit-node-end bra) 'invisible v)
        (put-text-property (treesit-node-start ket) (treesit-node-end ket) 'invisible v))))


(defun latex-ts-mode--should-fontify ()
  "Turn off markup fontify when inline."
  (when (and
         (equal major-mode 'latex-ts-mode)
         (not (equal (point) latex-ts-mode--pos)))
    ;; (message (format "setting text props at %d..." (point)))
    (when (and latex-ts-mode--last-start latex-ts-mode--last-end)
      (when latex-ts-mode-loudly
        (message (format "fontify last point: (%d %d)" latex-ts-mode--last-start latex-ts-mode--last-end)))
      (latex-ts-mode--fontify-at-point (point)
                                       latex-ts-mode--last-start
                                       latex-ts-mode--last-end
                                       latex-ts-mode-loudly))
    (latex-ts-mode--fontify-at-point (point) (pos-bol) (pos-eol) latex-ts-mode-loudly)
    (setq-local latex-ts-mode--pos (point)
                latex-ts-mode--last-start (pos-bol)
                latex-ts-mode--last-end (pos-eol))))

(defun latex-ts-mode--fontify-section (node override start end &optional _)
  (let* (
         (type (treesit-node-type node))
         (pos (or latex-ts-mode--pos (point-min)))
         (command (treesit-node-child-by-field-name node "command"))
         (name (treesit-node-child node 1))
         (node-start (treesit-node-start command))
         (node-end (treesit-node-end command))
         )
    (if (and (>= pos node-start) (<= pos (treesit-node-end name)))
        (progn
          (latex-ts-mode--set-curly-group-visibility name nil)
          (put-text-property node-start node-end 'invisible nil))
      (latex-ts-mode--set-curly-group-visibility name t)
      (put-text-property node-start node-end 'invisible t))
      ;; fontify \section s
      (treesit-fontify-with-override
       node-start node-end
       'latex-ts-mode-face-markup.environment
       override)
      ;; fontify the following name
      (treesit-fontify-with-override
       (treesit-node-start name) (treesit-node-end name)
       ;; (if (string-equal type "") 'superscript 'subscript)
       'latex-ts-mode-face-markup.heading.1
       override)))

;; NOTE `org-fold-core--property-symbol-get-create'
(defun latex-ts-mode--fontify-math-suscripts (node override start end &optional _)
  (let* ((node-start (treesit-node-start node))
         (node-end (treesit-node-end node))
         (type (treesit-node-type node))
         (pun (treesit-node-child node 0))
         (word (treesit-node-child node 1))
         ;; font-lock use `save-excursion' to fontify, so we need to manually save locations.
         (pos (or latex-ts-mode--pos (point-min)))
         ;; directly use the `display' text-property to mark raise levels
         (current-raise-level (cadr (get-text-property node-start 'display)))
         (raise-level (+ (or current-raise-level 0) (if (string-equal type "superscript") 0.2 -0.2))))

    (when latex-ts-mode-loudly
      (message (format "%d: fontifying suscripts of (%d, %d) with node at (%d, %d)..." pos start end node-start node-end)))

    (if (and (>= pos node-start) (<= pos node-end))
        ;; disable fontify inline, this part of code will not be triggered by `font-lock'.
        (progn
          (when latex-ts-mode-loudly (message (format  "unfontifying math suscripts... %d" pos)))
          (latex-ts-mode--set-curly-group-visibility word nil)
          (put-text-property (treesit-node-start pun) (treesit-node-end pun) 'invisible nil)
          (put-text-property (treesit-node-start word) (treesit-node-end word) 'display nil))
      ;; enable fontify when cursor is not inside the node
      (when latex-ts-mode-loudly (message (format  "fontifying math suscripts... %d" pos)))
      (latex-ts-mode--set-curly-group-visibility word t)
      (put-text-property (treesit-node-start pun) (treesit-node-end pun) 'invisible t)
      (put-text-property (treesit-node-start word) (treesit-node-end word) 'display
                         `(raise ,raise-level)))
      ;; to make `font-lock-mode' work
    (treesit-fontify-with-override node-start node-end
                                   (if (string-equal type "superscript")
                                       'superscript 'subscript) override)))

;; TODO may use `font-lock-ensure'?
(defun latex-ts-mode--fontify-at-point (pos beg end &optional loudly)
  "fontify at POS."
  (let ((latex-ts-mode--pos pos))
    (when loudly
      (message (format "mannual called fontify at %d, (%d %d)" pos beg end)))
    (treesit-font-lock-fontify-region beg end loudly)))

;; definition, type, assignment, builtin, constant, keyword, string-interpolation, comment, doc, string, operator, preprocessor, escape-sequence, and key.
(defvar latex-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'latex
   :feature 'builtin
   '(
     [(brack_group) (brack_group_argc)] @latex-ts-mode-face-variable.parameter
     ;; TODO to math
     [(operator) "=" "_" "^"] @font-lock-operator-face
     ;; punctuation.delimiter
     ((word) @font-lock-delimiter-face (:equal @font-lock-delimiter-face "&"))
     ;; punctuation.braket
     ["[" "]" "{" "}"] @font-lock-punctuation-face
     )
   ;; TODO this should not be in this group
   :language 'latex
   :feature 'markup
   '((begin
      command: _ @latex-ts-mode-face-markup.environment
      name: (curly_group_text (text) @latex-ts-mode-face-markup.environment.name))
     (end
      command: _ @latex-ts-mode-face-markup.environment
      name: (curly_group_text (text) @latex-ts-mode-face-markup.environment.name))
     )
   :language 'latex
   :feature 'definition
   :override t
   '(
     (new_command_definition
      command: _ @latex-ts-mode-face-function.macro
      declaration: (curly_group_command_name (_) @latex-ts-mode-face-function))

     (old_command_definition
      command: _ @latex-ts-mode-face-function.macro
      declaration: (_) @latex-ts-mode-face-function)

     (let_command_definition
      command: _ @latex-ts-mode-face-function.macro
      declaration: (_) @latex-ts-mode-face-function)

     (environment_definition
      command: _ @latex-ts-mode-face-function.macro
      name: (curly_group_text (_) @latex-ts-mode-face-markup.link))

     (theorem_definition
      command: _ @latex-ts-mode-face-function.macro
      name: (curly_group_text (_) @latex-ts-mode-face-markup.environment.name))

     (paired_delimiter_definition
      command: _ @latex-ts-mode-face-function.macro
      declaration: (curly_group_command_name (_) @latex-ts-mode-face-function))
     (label_definition
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (label_reference_range
      command: _ @latex-ts-mode-face-function.macro
      from:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link)
      to:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (label_reference
      command: _ @latex-ts-mode-face-function.macro
      names:
      (curly_group_text_list
       (_) @latex-ts-mode-face-markup.link))

     (label_number
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link)
      number: (_) @latex-ts-mode-face-markup.link)

     (citation
      command: _ @latex-ts-mode-face-function.macro
      keys: (curly_group_text_list) @latex-ts-mode-face-markup.link)

     (glossary_entry_definition
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (glossary_entry_reference
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (acronym_definition
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (acronym_reference
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (color_definition
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))

     (color_reference
      command: _ @latex-ts-mode-face-function.macro
      name:
      (curly_group_text
       (_) @latex-ts-mode-face-markup.link))
     )

   :language 'latex
   :feature 'function
   :override t
   '(
     (command_name) @font-lock-type-face
     ;; (command_name) @font-lock-function-name-face
     (text_mode "\\text" @font-lock-function-name-face)
     (caption command: _ @font-lock-function-name-face)
     (key_value_pair key: (_) @font-lock-variable-use-face value: (_))
     )

   ;; TODO `font-lock-comment-delimiter-face'
   :language 'latex
   :feature 'comment
   '(
     [
      (line_comment)
      (block_comment)
      (comment_environment)
      ] @font-lock-comment-face
     ((line_comment) @latex-ts-mode-face-keyword.directive
      (:match "^%% !TeX" @latex-ts-mode-face-keyword.directive)
      )
     )

   ;; TODO this should be in a function altogether
   :language 'latex
   :feature 'section
   :override t
   '(
     (title_declaration
      command: _ @latex-ts-mode-face-module
      options:
      (brack_group
       (_) @latex-ts-mode-face-markup.heading.1) :?
      text: (curly_group (_) @latex-ts-mode-face-markup.heading.1)
      ) 

     (author_declaration
      command: _ @latex-ts-mode-face-module
      authors: (curly_group_author_list (author):+ @latex-ts-mode-face-markup.heading.3))

     (chapter
      command: _ @latex-ts-mode-face-module
      toc:
      (brack_group
       (_) @latex-ts-mode-face-markup.heading.2) :?
      text:
      (curly_group
       (_) @latex-ts-mode-face-markup.heading.2))

     (part
      command: _ @latex-ts-mode-face-module
      toc:
      (brack_group
       (_) @latex-ts-mode-face-markup.heading.2) :?
      text:
      (curly_group
       (_) @latex-ts-mode-face-markup.heading.2))

     ;; TODO
     [(section) (subsection) (subsubsection)] @latex-ts-mode--fontify-section

     (paragraph
      command: _ @latex-ts-mode-face-module
      toc:
      (brack_group
       (_) @latex-ts-mode-face-markup.heading.6) :?
      text:
      (curly_group
       (_) @latex-ts-mode-face-markup.heading.6))

     (subparagraph
      command: _ @latex-ts-mode-face-module
      toc:
      (brack_group
       (_) @latex-ts-mode-face-markup.heading.6) :?
      text:
      (curly_group
       (_) @latex-ts-mode-face-markup.heading.6))
     )
   

   :language 'latex
   :feature 'math
   :override 't
   '(
     ;; (superscript superscript: (_) @latex-ts-mode-fontify-superscript)
     ;; (subscript subscript: (_) @subscript)
     [( superscript) (subscript)] @latex-ts-mode--fontify-math-suscripts
     (inline_formula "$" (_):* "$")
     )

   ))

;; (require 'latex-ts-mode)
;; (treesit-query-string
;;  "\\title{Long-range order and spontaneous symmetry breaking}"
;;  '()
;;  'latex
;;  )

;; (defun test1 (str)
;;   (let* (
;;          (pair (treesit-query-string str '([( superscript) (subscript)] @name) 'latex))
;;          (node (cdar pair))
;;          (child1 (treesit-node-child node 0))
;;          (child2 (treesit-node-child node 1))
;;          )
;;     (message "pair:")
;;     (print pair)
;;     (print (treesit-node-type child1))
;;     )
;;   )
;; (test1 "$a_b$")
;; (test1 "$a^b_c$")

;; (treesit-query-validate 'latex '(
;;      [( superscript) (subscript)] @latex-ts-mode--fontify-math-suscripts
;;      ))


(define-derived-mode latex-ts-mode latex-mode "LaTeX"
  "Major mode for LaTeX, with tree-sitter support."
  (when (treesit-ready-p 'latex)
    (treesit-parser-create 'latex)
    (setq-local treesit-font-lock-feature-list
                '((comment definition markup function)
                  (section)
                  (atrribute builtin math)
                  (bracket property variable))
                )
    (setq-local treesit-font-lock-settings latex-ts-mode--font-lock-settings)
    (add-hook 'post-command-hook #'latex-ts-mode--should-fontify nil t)
    ;; (remove-hook 'post-command-hook #'latex-ts-mode--should-fontify)
    (treesit-major-mode-setup)))

(if (treesit-ready-p 'latex)
    (add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-ts-mode)))

(provide 'latex-ts-mode)

;; NOTE
;; checkout `tree-sitter-hl.el' for highlighting
;; we need to query all queries in `highlight.scm',
;; and update `font-lock-fontify-region' with tree sitter,
;; which requires manual update and re-highlight.
;; TODO see `tree-sitter-hl--highlight-region-with-fallback'
;; and `tree-sitter-hl--invalidate', `tree-sitter-after-change-functions'.
;; TODO we may not need `font-lock-mode'; if we can direct use
;; `jit-lock-mode'. `jit-lock-mode' only fontifies the region we saw;
;; as we already encountered it in `magic-latex-buffer'.

;;; latex-ts-mode.el ends here
