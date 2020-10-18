
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

;;; Code:


(require 'server)
(unless (server-running-p)
  (server-start))

(set-face-attribute 'default nil :font "Liberation Mono for Powerline" )
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))

(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'multi-term)
(setq multi-term-program "/bin/zsh")

(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
                               auto-mode-alist))




(desktop-save-mode 1)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(set 'tab-width 4)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(c-basic-offset 4)
 '(custom-enabled-themes '(xresources))
 '(custom-safe-themes
   '("86704574d397606ee1433af037c46611fb0a2787e8b6fd1d6c96361575be72d2" "d8dc153c58354d612b2576fea87fe676a3a5d43bcc71170c62ddde4a1ad9e1fb" default))
 '(inhibit-startup-screen t)
 '(jdee-jdk-registry
   '(("10.0" . "/usr/lib/jvm/java-10-openjdk")
     ("10.0" . "/usr/lib64/jvm/java-10-openjdk")))
 '(jdee-server-dir "~/.emacs.d/jdeeserver/")
 '(package-selected-packages
   '(elpy company haskell-mode ediprolog jdee xresources-theme realgud buffer-move sr-speedbar ggtags racer flycheck-rust ## cargo gdb-mi quelpa-use-package hydra quelpa rust-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://framagit.org/steckerhalter/quelpa-use-package.git"))
(require 'quelpa-use-package)


(use-package gdb-mi :quelpa (gdb-mi :fetcher git
                                    :url "https://github.com/weirdNox/emacs-gdb.git"
                                    :files ("*.el" "*.c" "*.h" "Makefile"))
  :init
  (fmakunbound 'gdb)
  (fmakunbound 'gdb-enable-debug))




(defun indent-buffer ()
  "Indent current buffer according to major mode."
  (interactive)
  (indent-region (point-min) (point-max)))


(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))


(use-package elpy
  :ensure t
  :defer t
  :init
  (advice-add 'python-mode :before 'elpy-enable))


(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "~/rust/src") ;; Rust source code PATH

(progn
  
  (add-hook 'rust-mode-hook 'cargo-minor-mode)

  (add-hook 'rust-mode-hook
	    (lambda ()
	      (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  (add-hook 'racer-mode-hook #'company-mode)

  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

  (add-hook 'after-init-hook 'global-company-mode)

  )

(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

(setq speedbar-show-unknown-files t)

(defun load-material-theme (frame)
  (select-frame frame)
  (load-theme 'xresources))

(if (daemonp)
    (add-hook 'after-make-frame-functions #'load-material-theme)
  (load-theme 'xresources))

(provide '.emacs)


;;; .emacs ends here


