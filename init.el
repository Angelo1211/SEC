;; ---------------------------------------------------------------------------------------------------------------------------------------
;; TODOS
;; ---------------------------------------------------------------------------------------------------------------------------------------
;; + Here strings syntax highlighting
;; + List file procedures
;; + Ctrl-Backspace deletes too much

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

;; -- In-buffer completion
(use-package corfu
  :init
  (global-corfu-mode)
  :config
  (setq corfu-auto t))

(use-package consult)

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
         (define-key evil-normal-state-map (kbd "<SPC> m") `magit-status)
         (define-key evil-normal-state-map (kbd "SPC w") 'ace-window)
         (define-key evil-normal-state-map (kbd "SPC p") 'projectile-switch-project)
         (define-key evil-normal-state-map (kbd "SPC SPC") 'projectile-find-file)
         (define-key evil-normal-state-map (kbd "SPC /") 'consult-ripgrep)
         (define-key evil-normal-state-map (kbd "M-h") 'evil-jump-backward)
         (define-key evil-normal-state-map (kbd "M-l") 'evil-jump-forward)
	     (evil-mode 1))

(use-package treemacs-evil
  :after (treemacs evil))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Appearance
;; ---------------------------------------------------------------------------------------------------------------------------------------
;; -- Fullscreen
(toggle-frame-maximized)
(toggle-frame-fullscreen)

;; -- Scroll & menu bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)

;; -- Highlight Current Line
(global-hl-line-mode 1)

;; -- Trailing Whitespace
(setq-default show-trailing-whitespace t)

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
(use-package doom-modeline
	     :init
	     (doom-modeline-mode 1)
	     :config
         (setq doom-modeline-height 10)
         (setq doom-modeline-icon nil)
         (setq doom-modeline-buffer-encoding nil)
	     (setq doom-modeline-time t))

;; -- Font and Colors
(set-face-attribute `default nil
		    :family "Berkeley Mono"
		    :height 105
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

;; -- Which Key
(use-package which-key
  :config
  (which-key-mode))

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
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq backup-directory-alist '(("." . "~/EmacsBackups")))
(prefer-coding-system `utf-8)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Un-Reasonable Defaults
;; ---------------------------------------------------------------------------------------------------------------------------------------
(setq default-directory "/mnt/w/Nighthawk/")

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Key-bindings
;; ---------------------------------------------------------------------------------------------------------------------------------------
(bind-keys*
  ("C-c c" . visit-emacs-config)
  ("C-c a" . align-everything)
  ("C-c o" . treemacs))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Commands
;; ---------------------------------------------------------------------------------------------------------------------------------------
(defun visit-emacs-config ()
  "Open the config file"
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun align-everything (BEG END)
  "Align based on the rule I had in vscode."
  (interactive "r")
  (align-regexp BEG END "\\(\\s-*\\)[:=]"))

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Languages
;; ---------------------------------------------------------------------------------------------------------------------------------------
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'jai-mode)
(require 'hlsl-mode)

;; ---------------------------------------------------------------------------------------------------------------------------------------
;; Custom-Set-Variables
;; ---------------------------------------------------------------------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
