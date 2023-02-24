;; straight.el requires these two sadly
(defvar native-comp-deferred-compilation-deny-list nil)
(setq package-enable-at-startup nil)

;; This a substitute for package.el, instead of downloading tar files it will grab the source from github
;; and compile it. Much nicer imo. Plays well with ensure-package which is fantastic.
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Load in the org file where we've described our configuration as an .el file
(org-babel-load-file "~/.emacs.d/configuration.org")
