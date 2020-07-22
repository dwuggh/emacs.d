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

(require 'mode-local)

;;;###autoload
(defmacro setq-modes-local (modes &rest args)
  "Wrapper for `setq-mode-local' but with multiple modes"
  (if (symbolp modes)
      (setq-mode-local modes args)
    (dolist (mode modes)
      (setq-mode-local mode args)))

  )

;; from doom emacs
;;;###autoload
(defmacro plist-put+ (plist &rest rest)
  "Set each PROP VALUE pair in REST to PLIST in-place."
  `(cl-loop for (prop value)
            on (list ,@rest) by #'cddr
            do ,(if (symbolp plist)
                    `(setq ,plist (plist-put ,plist prop value))
                  `(plist-put ,plist prop value))))

;;;###autoload
(defmacro pushnew! (place &rest values)
  "Push VALUES sequentially into PLACE, if they aren't already present.
This is a variadic `cl-pushnew'."
  (let ((var (make-symbol "result")))
    `(dolist (,var (list ,@values) (with-no-warnings ,place))
       (cl-pushnew ,var ,place :test #'equal))))


(provide 'lib-hack)
;;; lib-hack.el ends here
