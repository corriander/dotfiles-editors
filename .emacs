;;;; Package configuration.
;; Sources:
;; http://stackoverflow.com/a/10093312/2921610
;; http://stackoverflow.com/a/14838150/2921610
;; http://toumorokoshi.wordpress.com/2012/02/16/automatic-package-installation-using-elpa-in-emacs-24/
;; Also, some stuff on initialisation order:
;; http://stackoverflow.com/a/18783152/2921610
(setq package-list '(evil org))	; list of desired packages
(require 'package)	; Package manager, included in emacs 24+
(package-initialize)	;; Initialize Package

;; Configure package archives/repos
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
						 ("marmalade" . "http://marmalade-repo.org/packages/")
						 ("org" . "http://orgmode.org/elpa/")))

;; Fetch available packages if there is no cache (i.e. fresh install)
(unless package-archive-contents 
  (package-refresh-contents))

;; Install missing packages NOTE: could potentially cause an issue in
;; the event of no internet and no locally install package? Edge case.
(dolist (pkg package-list)
  (unless (package-installed-p pkg)
	(package-install pkg)))


