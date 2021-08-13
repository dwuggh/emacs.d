(require 's)
(require 'dash)

(defvar predefined-keywords '(lambda)
  "predefined keywords for lisp")

(defmacro tl-test (&rest forms)
  `(assert ,`(and ,@forms)))

(defmacro maybe (&rest args)
  (case (length args)
    (0 nil)
    (1 `(car ,`(list ,@args)))
    (t `(list ,@args))))
  
(cl-defmacro cl-maybe (&key (just nil just-supplied-p))
  (if just-supplied-p `(cons ,just nil)))

(cl-maybe :just 1)
  
;; test for maybe
(tl-test
   (equal nil (maybe))
   (equal 1 (maybe 1))
   (equal '(1 2) (maybe 1 2))
 )

(defun maybe->>= (ma a->mb)
  "(>>=) :: Monad m a -> (a -> m b) -> m b"
  (when ma
    ;; (cond
    ;;  ((functionp a->mb) `(funcall ,a->mb ,ma))
    ;;  ((macrop a->mb) `(macroexpand ,amb ,ma)))
    ;; `(funcall ,a->mb ,ma)
    (eval
     (if (sequencep ma)
         `(,a->mb ,@ma)
       `(,a->mb ,ma))
     )
    ))
  
(tl-test
 (= 2 (maybe->>= 1 (lambda (a) (+ a 1))))
 (= 2 (maybe->>= (1 2) (lambda (a b) (+ a 1))))
 )

(defun tl-tokenize (input)
  "Tokenize INPUT.
Didn't handle comments."
  (->> input
       (s-replace "(" " ( ")
       (s-replace ")" " ) ")
       (s-replace "'" " ' ")
       (s-trim)
       (s-split "[ \t\n\r]+")
       )
  )

(tl-test
 (equal
  (tl-tokenize "'symbol")
  '("'" "symbol")
  )
 (equal
  (tl-tokenize "(lambda (&number a)\n (+ a 1))")
  '("(" "lambda" "(" "&number" "a" ")" "(" "+" "a" "1" ")" ")"))
 )
  
  
(cl-defmacro tl-atom (&key (number nil number-supplied-p) (symbol nil symbol-supplied-p))
  (cond
   (number-supplied-p `(list :atom ',`(:number ,number)))
   (symbol-supplied-p `(list :atom ',`(:symbol ,symbol)))
   )
  )

(cl-defmacro tl-sexp (&rest form)
  `(list :sexp (list :body ,@form))
  )

(tl-atom :number 1)
(tl-atom :symbol asdf)
(let ((a "asdf"))
  `(tl-atom :symbol ,a))
(tl-sexp (tl-atom :symbol "+") (tl-atom :number 1) (tl-atom :number 1))

;; (cl-defun tl-parse-token (tokens &key (result-prev nil result-prev-supplied-p))
(defun tl-parse-token (tokens &optional result-prev)
  (let* ((ele (car tokens))
         (result
          (cond
           ((not (eq (string-to-number ele) 0)) (tl-atom :number (string-to-number ele)))
           ((equal ele "0") (tl-atom :number 0))
           ((s-match "(" ele) (append result-prev (tl-sexp (cadr (tl-parse-token (cdr tokens))))))
           ;; ((s-match ")" ele) result-prev)
           ;; ((s-match "(" ele) (tl-sexp (tl-parse-token (cdr tokens))))
           ((s-match ")" ele) nil)
           ((s-match "[^ \t\r\n]+" ele) `(tl-atom :symbol ,ele))
           )))
    ;; (princ result)
    (maybe->>= `(',result)
               (lambda (result)
                 (list (cdr tokens) result)))
    (when result
      (list (cdr tokens) result))
    ))

(defun tl-parse-token-list (tokens &optional result-prev)
  (let ((res1 (tl-parse-token tokens result-prev)))
    (while res1)
    )
  )

(tl-parse-token '(")"))

(defun tl-parse (input)
  "INPUT is a string"
  (let ((fst (tl-tokenize input)))
    (when fst
      (let ((result (car fst))
            (token-next (cadr fst)))
        (tl-parse-token token-next result)))
    )
  )

(setq tl-test-prog "(lambda (&number a)\n (+ a 1))")
;; (tl-parse-token (tl-tokenize tl-test-prog) :result-prev '(:start))
(tl-parse-token (tl-tokenize tl-test-prog) '(:start))
(tl-parse tl-test-prog)
   
(defun tl-parse-sexp (tokens)
  "parse a s-expression"
  )
  

(provide 'tinylisp)
