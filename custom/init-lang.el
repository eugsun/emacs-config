;; -*- lexical-binding: t; -*-

(use-package flycheck
  :after lsp)

(use-package dap-mode
  :commands dap-debug)
(use-package lsp-mode
  :commands lsp
  ;; :init
  :config
  (setq lsp-file-watch-threshold 50000)
  (push "[/\\\\]\\.emacs\\.d/\\.extension\\'" lsp-file-watch-ignored-directories)
  (push "[/\\\\]\\.emacs\\.d/elpa\\'" lsp-file-watch-ignored-directories)
  (setq lsp-auto-guess-root t)
  (setq lsp-eldoc-render-all nil)
  (setq lsp-prefer-flymake nil)
  (setq lsp-enable-completion-at-point t)
  (setq gc-cons-threshold init-gc-cons-threshold)
  (setq read-process-output-max (* 3 1024 1024))
  (setq lsp-idle-delay 0.500)
  (setq lsp-completion-provider :capf))

(use-package lsp-ui
  :commands lsp-ui-mode)
(use-package lsp-treemacs
  :after lsp)

(use-package company
  :config
  (setq company-idle-delay 0.5)
  (setq company-dabbrev-downcase nil)
  (setq company-minimum-prefix-length 2)
  (global-company-mode t)

  ;; (use-package company-lsp
  ;;   :commands company-lsp
  ;;   :config
  ;;   (setq company-lsp-cache-candidates 'auto)
  ;;   (setq company-lsp-async t)
  ;;   )
  )


;; Dart
(use-package dart-mode
  :mode "\\.dart\\'"
  :config
  (setq dart-debug t)
  ;; server program
  (setq dart-sdk-path (concat (getenv "HOME") "/Apps/flutter/bin/cache/dart-sdk/"))
  (setq dart-analysis-server-bin (concat dart-sdk-path "bin/snapshots/analysis_server.dart.snapshot"))
  ;; (add-to-list 'eglot-server-programs `(dart-mode . ("dart" ,dart-analysis-server-bin "--lsp")))
  ;; project config
  (add-to-list 'projectile-project-root-files-bottom-up "pubspec.yaml")
  (add-to-list 'projectile-project-root-files-bottom-up "BUILD")
  ;; hooks. use flycheck instead of flymake
  ;; (advice-add 'dart-mode :after #'flymake-mode-off)
  ;; (advice-add 'dart-mode :after #'flycheck-mode-on-safe)
  ;; (advice-add 'dart-mode :after #'eglot-ensure)
  )
(use-package flutter
  :after dart-mode)
(use-package hover
  :after flutter
  :config
  (general-define-key
   :keymaps 'dart-mode-map
   :states '(normal visual)
   :prefix "SPC"
   "n h r" #'hover-run-or-hot-reload
   "n h R" #'hover-run-or-hot-restart))
(use-package lsp-dart
  :hook ((dart-mode . lsp)
         (dart-mode . dap-dart-setup))
  :custom
  (lsp-dart-flutter-widget-guides nil))

;;; Configuration of Android projects use Groovy/Gradle
(use-package groovy-mode
  :mode "\\.gradle\\'")

;; yaml
(use-package yaml-mode
  :mode "\\.yaml\\'")

;; Racket
(use-package racket-mode
  :mode "\\.rkt\\'")


;; Python
(use-package python-mode
  :mode "\\.py\\'"
  :custom
  (python-shell-interpreter "ipython"))
(use-package python-black
  :after python-mode
  :config
  (general-define-key
   :keymaps 'python-mode-map
   :prefix "SPC"
   :states '(normal visual)
   "lf" 'python-black-buffer
   ))
(use-package py-isort
  ;; requires:
  ;; pip install isort
  :after python-mode)
(use-package pyvenv
  :after python-mode)
(use-package lsp-pyright
  ;; :mode "\\.py\\'"
  ;; :after python-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred)))
  )


(use-package fountain-mode
  :mode "\\.fountain\\'")
(use-package imenu-list
  :commands imenu-list-smart-toggle)

(use-package markdown-mode
  :mode "\\.md\\'")

(use-package ink-mode
  :mode "\\.ink\\'"
  :config
  (add-hook 'ink-mode-hook 'olivetti-mode)
  (defun ink-mode-open ()
    (interactive)
    (let (($path (buffer-file-name)))
      (when (executable-find "open")
        (shell-command (format "open -a Inky \"%s\"" $path))
        )
      )
    )
  (general-define-key
   :keymaps 'ink-mode-map
   "C-c C-c" 'ink-mode-open
   )
  )

;; Clojure
(use-package clojure-mode
  :mode "\\.clj\\'")
(use-package cider
  :after clojure-mode)


;; CSharp
(use-package csharp-mode
  :mode "\\.cs\\'"
  :init
  ;; To make omnisharp work, replace the server installed mono to the global one
  (advice-add 'csharp-mode :after #'lsp)
  (add-hook 'csharp-mode-hook 'flycheck-mode))
(use-package csproj-mode
  :after csharp-mode)

;; (use-package omnisharp
;;   :after csharp-mode
;;   :config
;;   (add-to-list 'company-backends 'company-omnisharp)
;;   (defun my-csharp-mode-setup ()
;;     (omnisharp-mode)
;;     (company-mode)
;;     (flycheck-mode)

;;     (setq indent-tabs-mode nil)
;;     (setq c-syntactic-indentation t)
;;     (c-set-style "ellemtel")
;;     (setq c-basic-offset 4)
;;     (setq truncate-lines t)
;;     (setq tab-width 4)
;;     (setq evil-shift-width 4)
;;     (electric-pair-local-mode 1)

;;     (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
;;     (local-set-key (kbd "C-c C-c") 'recompile))
;;   (add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)

;;   (general-define-key
;;    :keymaps 'omnisharp-mode-map
;;    "C-," '(omnisharp-run-code-action-refactoring :which-key "code action")
;;    "C-=" '(omnisharp-code-format-entire-file :which-key "reformat")
;;    )
;;   (general-define-key
;;    :keymaps 'omnisharp-mode-map
;;    :states '(normal visual)
;;    "gd"  'omnisharp-go-to-definition
;;    "gD"  'omnisharp-go-to-definition-other-window
;;    )
;;   )

(use-package json-mode
  :mode "\\.json\\'"
  :config
  (setq js-indent-level 2)
  )


(use-package haskell-mode
  :mode "\\.hs\\'")
(use-package lsp-haskell
  :after (haskell-mode lsp)
  :config
  (setq lsp-haskell-process-path-hie "hie-wrapper")
  )


(use-package sml-mode
  :mode "\\.sml\\'")

;; Go
(use-package go-mode
  :mode "\\.go\\'"
  :hook ((go-mode . lsp)
         (go-mode . yas-minor-mode))
  :init
  (defun lsp-go-install-save-hooks ()
    (add-hook 'before-save-hook #'lsp-format-buffer t t)
    (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'lsp-go-install-save-hooks))
