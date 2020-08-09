
  (use-package rime
    :straight (rime :type git
                    :host github
                    :repo "DogLooksGood/emacs-rime"
                    :files ("*.el" "Makefile" "lib.c"))
    :config
    (defun rime-evil-escape-advice (orig-fun key)
      "advice for `rime-input-method' to make it work together with `evil-escape'.
    Mainly modified from `evil-escape-pre-command-hook'"
      (if rime--preedit-overlay
	  ;; if `rime--preedit-overlay' is non-nil, then we are editing something, do not abort 
	  (apply orig-fun (list key))
	(when (featurep 'evil-escape)
	  (let* (
		 (fkey (elt evil-escape-key-sequence 0))
		 (skey (elt evil-escape-key-sequence 1))
		 (evt (read-event nil nil evil-escape-delay))
		 )
	    (cond
	     ((and (characterp evt)
		   (or (and (char-equal key fkey) (char-equal evt skey))
		       (and evil-escape-unordered-key-sequence
			    (char-equal key skey) (char-equal evt fkey))))
	      (evil-repeat-stop)
	      ;; (rime--escape)
	      (evil-normal-state))
	     ((null evt) (apply orig-fun (list key)))
	     (t
	      (apply orig-fun (list key))
	      (if (numberp evt)
		  (apply orig-fun (list evt))
		(setq unread-command-events (append unread-command-events (list evt))))))))))

    ;; (advice-add 'rime-input-method :around #'rime-evil-escape-advice)
    :custom
    (default-input-method "rime")
    :config
    (setq-default rime-show-candidate 'posframe)
    (setq-default rime-user-data-dir (concat user-emacs-directory "rime/")))



(advice-remove 'rime-input-method 'rime-evil-escape-advice)
(advice-add 'rime-input-method :around #'rime-evil-escape-advice)

(use-package jieba
  :straight (jieba :type git
		   :host github
		   :repo "cireu/jieba.el"
		   :files ("*.el" "*.js" "package.json"))
  :config
  (jieba-mode)
  )

(use-package goldendict
  :defer t
  )

(use-package youdao-dictionary
  :defer t)


(dwuggh/leader-def
 "l" '(:ignore t :wk "language")
 "lg" '(goldendict-dwim :wk "goldendict")
 "la" '(youdao-dictionary-search-at-point-posframe :wk "youdao dict")
 "lv" '(youdao-dictionary-play-voice-at-point :wk "youdao voice")
 )

(provide 'init-chinese)
