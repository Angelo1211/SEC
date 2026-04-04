;;; jai-mode.el --- Major mode for the Jai programming language -*- lexical-binding: t; -*-

;; Author: Angel Ortiz
;; Version: 0.1
;; Package-Requires: ((emacs "29.1"))
;; Keywords: languages

;;; Commentary:
;; A major mode for the Jai programming language.

;;; Code:

(defgroup jai nil
  "Support for the Jai programming language."
  :group 'languages
  :prefix "jai-")

(defconst jai-keywords
  '("if" "ifx" "else" "then" "while" "for" "switch" "case"
    "return" "continue" "break" "defer"
    "using" "size_of" "type_of" "cast" "type_info"
    "null" "true" "false" "xx" "context" "operator"
    "push_context" "is_constant" "inline" "no_inline"
    "struct" "enum" "enum_flags" "union"))

(defconst jai-typenames
  '("int" "u64" "u32" "u16" "u8"
    "s64" "s32" "s16" "s8"
    "it" "it_index"
    "float" "float32" "float64"
    "string" "bool" "void"))

(defun jai-wrap-word-rx (s)
  (concat "\\<" s "\\>"))

(defconst jai-number-rx
  (rx (and
       symbol-start
       (or (and (+ digit) (opt (and (any "eE") (opt (any "-+")) (+ digit))))
           (and "0" (any "xX") (+ hex-digit)))
       symbol-end)))

(defconst jai-font-lock-keywords
  `(
    ;; Annotations and directives first to avoid keyword overrides
    ("#\\w+" . font-lock-preprocessor-face)
    ("@\\w+" . font-lock-preprocessor-face)

    ;; Keywords
    (,(regexp-opt jai-keywords 'words) 0 font-lock-keyword-face keep)

    ;; Custom types
    (":\\s-*\\(\\[.*\\]\\)?\\**\\w*" 0 font-lock-type-face)

    ;; Built-in types
    (,(regexp-opt jai-typenames 'words) 0 font-lock-type-face keep)

    ;; Procedure declarations: name :: (
    ("\\(\\w+\\)\\s-*::\\s-*\\(?:inline\\|no_inline\\)?\\s-*(" 1 font-lock-function-name-face)

    ;; Function calls: name( but not declarations
    ("\\(\\w+\\)\\s-*(" 1 font-lock-function-name-face keep)

    ;; Operators (multi-char first, then single)
    (,(regexp-opt '("::" "->" "==" "!=" "<=" ">=" "&&" "||"
                    ":" ";" "+" "-" "*" "/" "%" "&" "|" "^" "!" "=" "<" ">" "~" "`"))
     . font-lock-keyword-face)

    ;; Brackets, parens, square brackets
    ("[][(){}]" . font-lock-function-name-face)

    ;; Number literals (decimal, float, hex)
    (,(jai-wrap-word-rx jai-number-rx) . font-lock-constant-face)
    ))


(defconst jai-mode-syntax-table
  (let ((table (make-syntax-table)))

    ;; _ is part of a word, so M-f treats my_variable as one token
    (modify-syntax-entry ?_ "w" table)

    ;; \ is an escape character inside strings
    (modify-syntax-entry ?\\ "\\" table)

    ;; " delimitates strings
    (modify-syntax-entry ?\" "\"" table)

    ;; Operators are punctuation — keeps them out of word motion
    (dolist (c '(?+ ?- ?% ?& ?| ?^ ?! ?= ?< ?> ??))
      (modify-syntax-entry c "." table))

    ;; Comment syntax
    (modify-syntax-entry ?/  ". 124b" table)
    (modify-syntax-entry ?*  ". 23n"  table)
    (modify-syntax-entry ?\n "> b"    table)

    table)
  "Syntax table for `jai-mode'.")

;;;###autoload
(define-derived-mode jai-mode prog-mode "Jai"
  "Major mode for editing Jai source files."
  :syntax-table jai-mode-syntax-table
  :group 'jai
  (setq-local font-lock-defaults `(jai-font-lock-keywords)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.jai\\'" . jai-mode))

(provide 'jai-mode)
