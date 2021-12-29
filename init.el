;; Configure package.el to include MELPA.
(require 'package)
(add-to-list 'package-archives
         '("melpa-stable" . "http://stable.melpa.org/packages/"))
(add-to-list 'package-archives
         '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Ensure that packages are intitialized
;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh isntallation? So we'll want to update the package repository and
;; install use-package before loading the literate configuration
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))


;;Load in the org mode file emacs source code, allows us to have
(org-babel-load-file "~/.emacs.d/configuration.org")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rainbow-delimiters racket-mode evil-magit magit evil-org evil org-bullets use-package auto-compile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
