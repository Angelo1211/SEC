;; ---------------------------------------------------------------------------------------------------------------------------------------
;; TODOS
;; ---------------------------------------------------------------------------------------------------------------------------------------
;; + Comments on text files
;; + Auto-save is still doing whatever it wants

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Packages
;; ---------------------------------------------------------------------------------------------------------------------------------------
(require `package)
(add-to-list `package-archives `("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; -- Fetch packages
(unless package-archive-contents
  (package-refresh-contents))

;; -- Ensure packages exist by default
(require `use-package)
(setq use-package-always-ensure t)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Auto-Complete & Search
;; ---------------------------------------------------------------------------------------------------------------------------------------
(use-package vertico
  :init
  (vertico-mode))

;; -- Completion at point overloading
(use-package cape
  :init
  ;; always good to have this available
  (add-to-list 'completion-at-point-functions #'cape-dabbrev))

;; -- In-buffer completion
(use-package corfu
  :config
  (setq corfu-auto t)
  (setq corfu-cycle t)
  (setq corfu-auto-prefix 3)
  (setq corfu-auto-delay 0.1)
  (setq corfu-echo-documentation 0.25)
  :init
  (global-corfu-mode))

(use-package consult)

;; -- Supercharge completion like in everything
(use-package orderless
  :custom
  (completion-styles '(orderless basic)))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Window Management
;; ---------------------------------------------------------------------------------------------------------------------------------------
(use-package ace-window
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Project Management
;; ---------------------------------------------------------------------------------------------------------------------------------------
(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching 'persistent)
  (setq projectile-project-search-path `("mnt/w")))

;; --  Source Control
;; NOTE(AO) Unfortunately, interactions with WSL2 make this unusable, alas
;;(use-package magit)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Directory Traversal
;; ---------------------------------------------------------------------------------------------------------------------------------------
(use-package treemacs
  :config
  (treemacs-git-mode -1))

(use-package treemacs-projectile
  :after (treemacs projectile))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Vim Emulation
;; ---------------------------------------------------------------------------------------------------------------------------------------
(use-package evil
	     :init
	     :config

        ;; Center search results
        ;; https://www.reddit.com/r/emacs/comments/6ewd0h/how_can_i_center_the_search_results_vertically/
        (advice-add 'evil-search-next :after
                    (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
        (advice-add 'evil-search-previous :after
                    (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))

         ;; Redo support
         (evil-set-undo-system 'undo-redo)

         ;; Visual mode
         (define-key evil-visual-state-map (kbd "SPC a") 'ao/align-everything)

         ;; Normal mode
         (define-key evil-normal-state-map (kbd "SPC r t") 'visual-replace-thing-at-point)
         (define-key evil-normal-state-map (kbd "SPC r r") 'visual-replace)

         (define-key evil-normal-state-map (kbd "SPC i") 'consult-imenu-multi)
         (define-key evil-normal-state-map (kbd "SPC b") 'consult-buffer)
         (define-key evil-normal-state-map (kbd "SPC f") 'ao/consult-at-point)
         (define-key evil-normal-state-map (kbd "SPC /") 'consult-ripgrep)
         (define-key evil-normal-state-map (kbd "SPC SPC") 'consult-line)
         (define-key evil-normal-state-map (kbd "SPC w") 'ace-window)
         (define-key evil-normal-state-map (kbd "SPC p") 'projectile-switch-project)
         (define-key evil-normal-state-map (kbd "SPC o") 'projectile-find-file)
         (define-key evil-normal-state-map (kbd "M-h") 'evil-jump-backward)
         (define-key evil-normal-state-map (kbd "M-l") 'evil-jump-forward)

	     (evil-mode 1))

(use-package treemacs-evil
  :after (treemacs evil))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Appearance
;; ---------------------------------------------------------------------------------------------------------------------------------------
;; -- Fullscreen
;; https://emacs.stackexchange.com/questions/51668/if-frame-is-maximized
(when (not(eq (frame-parameter nil 'fullscreen) 'maximized))
    (progn
        (toggle-frame-maximized)
        (toggle-frame-fullscreen)))

;; -- Scroll & menu bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)

;; -- Highlight Current Line
(global-hl-line-mode 1)

;; -- Whitespace
;; https://github.com/VernonGrant/discovering-emacs/blob/main/show-notes/4-using-whitespace-mode.md
(global-whitespace-mode 1)
(setq-default show-trailing-whitespace t)
(setq whitespace-style '(face spaces space-mark tabs tab-mark))
(setq whitespace-display-mappings
      '((space-mark ?\  [?\·] [?.])       ; space → middle dot (U+00B7)
        (tab-mark   ?\t [?\» ?\t] [?\\ ?\t])))
(custom-set-faces '(whitespace-space ((t (:foreground "#535C6E" :background unspecified)))))

;; -- Always open two windows
(when(< (count-windows) 2)
  (split-window-horizontally))

;; -- Theme
(use-package doom-themes
  :config
  (doom-themes-visual-bell-config)
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (load-theme 'doom-nord t)
  (set-face-background 'hl-line "#005555")
  (set-face-foreground 'font-lock-comment-face "#ffAF00")
  (set-face-foreground 'font-lock-string-face  "#39FF14")
  (set-face-foreground 'font-lock-constant-face  "#e87650"))

;; -- Modeline
(display-time-mode 1)
(use-package mood-line
    :config
    (mood-line-mode))


;; -- Font and Colors
(set-face-attribute `default nil
		    :family "Berkeley Mono"
		    :height 103
		    :weight `normal
		    :width `normal)

;; -- Ligatures
(use-package ligature
  :config
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  (global-ligature-mode t))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Editing
;; ---------------------------------------------------------------------------------------------------------------------------------------
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

;; -- auto close bracket insertion
(electric-pair-mode 1)
(setq electric-pair-pairs
      '((?\" . ?\")
        (?\{ . ?\})
        (?\[ . ?\])))

;; -- Scrolling by a single line
(setq scroll-step 1)
(setq scroll-conservatively 10000)

;; -- Which Key
(use-package which-key
  :config
  (which-key-mode))

;; -- Search and Replace
(use-package visual-replace
    :defer t
    :config
    (setq visual-replace-default-to-full-scope t)
    (visual-replace-global-mode 1))

;; -- Jump to definition
(use-package dumb-jump
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; -- Abbreviations
(defun insert-file-header ()
  (insert (format "// Created(AO): %s" (format-time-string "%Y-%m-%d (%H:%M:%S)"))))
(define-abbrev global-abbrev-table "fh" "" 'insert-file-header)
(setq-default abbrev-mode t)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Reasonable Defaults
;; ---------------------------------------------------------------------------------------------------------------------------------------
(setq inhibit-startup-screen t)
(setq auto-window-vscroll nil)
(prefer-coding-system `utf-8)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Backups & Auto-Saves
;; ---------------------------------------------------------------------------------------------------------------------------------------
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq backup-directory-alist '(("." . "~/EmacsBackups")))
(setf kill-buffer-delete-auto-save-files t)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Key-bindings
;; ---------------------------------------------------------------------------------------------------------------------------------------
(bind-keys*
 ("M-o"           . ao/open-buffer-in-other-window )
 ("C-<tab>"       . next-buffer)
 ("C-<backspace>" . ao/backward-kill-word)
 ("C-c c"         . ao/visit-emacs-config)
 ("C-x C-b"       . ibuffer)
 ("C-c o"         . treemacs))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Commands
;; ---------------------------------------------------------------------------------------------------------------------------------------
(defun ao/visit-emacs-config ()
  "Open the config file"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun ao/align-everything (BEG END)
  "Align based on the rule I had in vscode."
  (interactive "r")
  (align-regexp BEG END "\\(\\s-*\\)[:=]"))

(defun ao/get-project-root ()
    (when (fboundp `projectile-project-root) (projectile-project-root)))
(defun ao/consult-at-point ()
    (interactive)
    (consult-ripgrep (ao/get-project-root)(thing-at-point 'symbol)))

(defun ao/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
             (while (looking-back "[ \n]")
               (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))

(defun ao/open-buffer-in-other-window ()
  	(interactive)

	;; If there are less than two then split windows
	(when(< (count-windows) 2)
		(split-window-horizontally))

	;; Store the current buffer and line
	(setq buffer (current-buffer))
	(setq line (line-number-at-pos))

	;; Switch to the other window
  	(other-window 1)
	(switch-to-buffer buffer)
  	(evil-scroll-line-to-top line))

;; -- Source: https://www.emacswiki.org/emacs/misc-cmds.el
(defun ao/revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Work-Life Balance
;; ---------------------------------------------------------------------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(load "home.el")
(load "work.el")

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Languages
;; ---------------------------------------------------------------------------------------------------------------------------------------
(require 'hlsl-mode)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Custom-Set-Variables
;; ---------------------------------------------------------------------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
    '(all-the-icons cape consult corfu doom-modeline doom-themes dumb-jump
                    evil-lion indent-bars ligature magit mood-line
                    orderless rainbow-delimiters simple-modeline
                    tree-sitter-langs treemacs-evil
                    treemacs-projectile treesit-auto vertico
                    visual-replace which-key)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
