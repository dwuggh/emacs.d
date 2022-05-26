;;; org-paste-image.el --- better image pasting utility -*- lexical-binding: t; -*-
;;
;; Copyright © 2015–present Mark Karpov <markkarpov92@gmail.com>
;; Copyright © 2012–2013 Magnar Sveen <magnars@gmail.com>
;;
;; Author: duwggh <dwuggh@gmail.com>
;; URL: 
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.4") (cl-lib "0.5") (org "9.0.0"))
;; Keywords: convenience
;;
;; This file is not part of GNU Emacs.
;;
;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:


;;; Code:

(defconst org-paste-image-extensions-default
  '("png" "jpeg" "jpg" "svg" "gif" "tiff" "bmp" "psd" "raw" "webp")
  "file formats that should be identified as image."
  )

(defcustom org-paste-image-store-directory ".img/"
   "the directory where images will be stored, default is \".img/\". "
   :type 'string
   )

(defun org-paste-image-file-path-p (path)
  "return nil if `path' is neither a (start with `~/' or `/' in unix)
file path nor a string start with `file://'
return the correspond path otherwise"
  (if (string-prefix-p "file:\/\/" path)
      (setq path (substring path 7 nil)))
  (if (file-name-absolute-p path)
      path)
  )

;; (defun org-paste-image-full-path (path)
;;   "convert file path to full path. Include file://"
;;   (let ((path (if (string-prefix-p "file:\/\/" path)
;;        (substring path 7 nil)
;;      path)))
;;     (file-truename path)))

(defun org-paste-image-format-path (path)
  "format the path, cut file://"
  (if (string-prefix-p "file:\/\/" path)
      (substring path 7 nil)
    path))

(defun org-paste-image-file-is-image-p  (file)
  "return nil if `file' is not an existing image file, return `file' otherwise."
  (let ((extension (downcase (file-name-extension file))))
    (and (member extension org-paste-image-extensions-default)
     (file-exists-p file))))


(defun org-paste-image-new-name-default (ext)
  "default name for image. EXT is the extension name for image."
  (concat (current-time-string) "." ext))


;; TODO interactively set new name
(defun org-paste-image-copy-to-local (image name)
  "copy IMAGE to `org-paste-image-store-directory'.
NAME should contain extension."
  (when (org-paste-image-file-is-image-p img)
    (let* ((image (file-truename image))
       (new-image (concat org-paste-image-store-directory name)))
      ;; create directory
      (unless (file-exists-p org-paste-image-store-directory)
    (make-directory org-paste-image-store-directory))
      (copy-file image new-image)
      new-image)))

;; (defun org-paste-image-insert-for-yank-advice (str)
;;   "advice for `insert-for-yank'."
;;   (let ((img-maybe (org-paste-image-full-path str))))
;;   )

;; better image pasting
(defun org-paste-image-yank (&optional register)
  "copy image to `org-paste-image-store-directory' when pasting a image path"
  (interactive "*P")
  (let* ((text (if register
                   (evil-get-register register)
                 (current-kill 0)))
     (text (org-paste-image-format-path text)))
    (when (and (org-paste-image-file-is-image-p text)
           (equal major-mode 'org-mode))
      ;; (ivy-read "name:" 'read-file-name-internal
      ;;        :initial-input ())
      (let* ((ext file-name-extension text)
         (name (org-paste-image-new-name-default ext))
         (path (org-paste-image-copy-to-local text name))
         (content (format "[[%s]]" path)))
    (ivy-read (concat "new name: ") #'read-file-name-internal
          :matcher #'counsel--find-file-matcher
          :initial-input name
          :require-match nil
          :caller 'org-paste-image-yank
          :action 
     )
    ;; (completing-read "new name: " #'read-file-name-internal
    ;;                  nil nil name
    ;;                  )
    ;; read-file-name
    (insert-for-yank content)))))


(defun org-paste-image-selected-copy-to-local (beg end)
  "move image from `beg' to `end' to `org-paste-image-store-directory'"
  (interactive "r")
  (let ((text (filter-buffer-substring beg end)))
    (set 'text (org-paste-image-copy-to-local text))
    (if text
        (progn
          (evil-delete beg end)
          (insert text)
          )
      (message "cannot convert"))))

(provide 'org-paste-image)
