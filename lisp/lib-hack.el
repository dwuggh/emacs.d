;;; lib-hack.el --- description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2020 dwuggh
;;
;; Author: dwuggh <http://github/dwuggh>
;; Maintainer: dwuggh <dwuggh@gmail.com>
;; Created: July 19, 2020
;; Modified: July 19, 2020
;; Version: 0.0.1
;; Keywords:
;; Homepage: https://github.com/dwuggh/lib-hack
;; Package-Requires: ((emacs 27.0.91) (cl-lib "0.5"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  description
;;
;;; Code:

;; (defmacro add-hook- (hook &rest args)
;;   "use lambda"
;;   ;; (declare args defun)
;;   (add-hook hook
;;             `(lambda ()
;;               ,@args)))

;;;###autoload
(defmacro add-hook+ (hooks fun &optional append local)
  "add hook for multiple module"
  (dolist (hook hooks)
    (add-hook hook fun append local)))

;;;###autoload
(defmacro add-hook- (hook funcbody funcname &optional depth local)
  "Wrapper for `add-hook'."
  `(defun ,funcname ()
     ,funcbody)
  `(add-hook ,hook ',funcname)
  )


(provide 'lib-hack)
;;; lib-hack.el ends here
