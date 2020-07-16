;;; package --- my init file

;;; Commentary:

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ADD MELPA REPOSITORY ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  )
(package-initialize)


;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; BOOTSTRAP USE-PACKAGE ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(package-initialize)
(if (not (package-installed-p 'use-package))
    (progn
      (package-refresh-contents)
      (package-install 'use-package)))

;;;;;;;;;;;;;;;;;;;;;;;;
;; CREATE CUSTOM FILE ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(let ((custom-file-path "~/.emacs.d/custom.el"))
  (if (not (file-exists-p custom-file-path))
      (shell-command (format "touch %s" custom-file-path)))
  (setq custom-file custom-file-path)
  (load custom-file))

;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL SETTINGS ;;
;;;;;;;;;;;;;;;;;;;;;;
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq vc-follow-symlinks t)
(setq ring-bell-function 'ignore)

(electric-pair-mode 1)
(show-paren-mode 1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode -1)
;; (split-window-horizontally)
(global-hl-line-mode 1)
(global-display-line-numbers-mode 1)

;;;;;;;;;;;;;;
;; PACKAGES ;;
;;;;;;;;;;;;;;

(use-package helm-themes
  :ensure t)

(use-package doom-themes
  :ensure t
  :config
  (set-frame-font "Source Code Pro 10")
  (load-theme 'doom-one-light))

(use-package doom-modeline
  :ensure t
  :disabled t
  :config (doom-modeline-mode 1))

(use-package powerline
  :ensure t
  :disabled t
  :init
  (powerline-center-theme))

(use-package all-the-icons
  :ensure t)

(use-package org
  :ensure t
  :config
  (add-hook 'after-save-hook 'org-table-recalculate-buffer-tables))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :ensure t)



(use-package key-chord
  :ensure t)

(use-package evil
  :ensure t
  :disabled t
  :config
  (setq key-chord-two-keys-delay 0.5)
  (setq evil-want-C-u-scroll t)
  (setq evil-insert-state-cursor 'box)
  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
  (key-chord-mode 1)
  (evil-mode 1))

(use-package evil-surround
  :ensure t
  :init
  (global-evil-surround-mode 1))

(use-package helm
  :ensure t
  :init
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x r b") #'helm-filtered-bookmarks)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-s") #'helm-occur)
  (global-set-key (kbd "C-x C-r") #'helm-recentf)
  (global-set-key (kbd "C-x C-b") #'helm-buffers-list)

  (global-set-key (kbd "C-x b") #'helm-buffers-list)
  (global-set-key (kbd "C-x C-l") #'helm-locate))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package helm-projectile
  :ensure t
  :config (helm-projectile-on))

(use-package ripgrep
  :ensure t)

(use-package elpy
  :ensure t
  :init
  (add-hook 'python-mode-hook
	    #'(lambda () (add-hook 'after-save-hook 'elpy-black-fix-code nil 'make-it-local)))
  (elpy-enable))

(use-package company
  :ensure t
  :bind ("C-x C-o" . company-complete)
  :init
  (global-company-mode)
  (define-key company-active-map (kbd "\C-n") 'company-select-next)
  (define-key company-active-map (kbd "\C-p") 'company-select-previous)
  (define-key company-active-map (kbd "\C-d") 'company-show-doc-buffer)
  (define-key company-active-map (kbd "M-.") 'company-show-location)
  (define-key company-active-map (kbd "C-x C-o") 'company-complete)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2))

(use-package company-quickhelp
  :ensure t
  :init (add-hook 'global-company-mode-hook #'company-quickhelp-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode t))

(use-package which-key
  :ensure t
  :config (which-key-mode))

(use-package undo-tree
  :ensure t
  :config (global-undo-tree-mode t)
  (setq undo-tree-visualizer-diff t))

(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package cider
  :ensure t
  :config (cider-mode 1))

(use-package avy
  :ensure t
  :bind ("C-," . avy-goto-char-timer))

(use-package yaml-mode
  :ensure t)

(use-package toml-mode
  :ensure t)

(use-package rainbow-mode
  :ensure t)

(use-package fsharp-mode
  :bind (:map fsharp-mode-map)
  ("M-RET" . fsharp-eval-region)
  :ensure t)

(use-package exec-path-from-shell
  :ensure t)

(use-package yasnippet
  :ensure t
  :init (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t)

(use-package go-mode
  :ensure t
  :init
  (progn
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)))

(use-package go-eldoc
  :ensure t
  :init
  (add-hook 'go-mode-hook 'go-eldoc-setup))

(use-package paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'paredit-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'paredit-mode)
  (add-hook 'lisp-mode-hook #'paredit-mode)
  (add-hook 'clojure-mode-hook #'paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'paredit-mode))

(use-package evil-paredit
  :ensure t
  :config
  (add-hook 'emacs-lisp-mode-hook #'evil-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'evil-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'paredit-mode)
  (add-hook 'ielm-mode-hook #'evil-paredit-mode)
  (add-hook 'lisp-mode-hook #'evil-paredit-mode)
  (add-hook 'clojure-mode-hook #'evil-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'evil-paredit-mode))

(use-package irony
  :ensure t
  :config
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(use-package haskell-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;;;;;;;;;;;;;;;;;;;;;;
;; CUSTOM FUNCTIONS ;;
;;;;;;;;;;;;;;;;;;;;;;

(defun list-programming-modes ()
  "List of my programming hooks."
  (interactive)
  (list 'c++-mode-hook
	'c-mode-hook
	'java-mode-hook
	'clojure-mode-hook
	'emacs-lisp-mode-hook))

(defun indent-buffer ()
  "Formats the current buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun setup-custom-functions ()
  "Initiate all of our custom settings."
  (interactive)
  (global-set-key [f12] 'indent-buffer)
  (dolist (el (list-programming-modes))
    (add-hook el #'(lambda () (add-hook 'after-save-hook 'indent-buffer nil 'make-it-local)))))

(setup-custom-functions)

(provide 'init)
;;; init.el ends here
