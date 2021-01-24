;; -*- lexical-binding: t; -*-

(when (display-graphic-p)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  )
(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Paths
(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :ensure t
  :custom
  (exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-variables
        `("PATH" "MANPATH" "WORKON_HOME"))
  :config
  (exec-path-from-shell-initialize))

;; IQA allows find/reload of init file
(use-package iqa
  :ensure t
  :config
  (iqa-setup-default))


;; Workspaces
(use-package perspective
  :ensure t
  :config
  (persp-mode))


;; Evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-disable-insert-state-bindings t)
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))
(use-package evil-terminal-cursor-changer
  :after evil
  :ensure t
  :init
  (setq evil-motion-state-cursor 'box)  ; █
  (setq evil-visual-state-cursor 'box)  ; █
  (setq evil-normal-state-cursor 'box)  ; █
  (setq evil-insert-state-cursor 'bar)  ; ⎸
  (setq evil-emacs-state-cursor  'hbar) ; _
  :config
  (unless (display-graphic-p)
    (evil-terminal-cursor-changer-activate) ; or (etcc-on)
    ))


;; Ivy
(use-package rg
  :ensure t)
(use-package ivy
  :ensure t
  :diminish ivy-mode
  :init
  (setq ivy-use-virtual-buffer t)
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode 1))
(use-package counsel
  :ensure t
  :init
  (setq counsel-rg-base-command
        "rg -S -M 140 --no-heading --line-number --color never %s ."))
(use-package swiper
  :ensure t)


;; Show keybinding hints
(use-package which-key
  :ensure t
  :config
  (which-key-mode 1))


;; All The Icons
(use-package all-the-icons
  :ensure t)
(use-package neotree
  :ensure t
  :init
  ;; NeoTree theme uses the icons
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  :config
  (evil-set-initial-state 'neotree-mode 'emacs)
  )


;; Editor
(use-package undo-tree
  :ensure t
  :config
  (global-undo-tree-mode)
  (setq evil-undo-system 'undo-tree))


(use-package multiple-cursors
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode 1))
(use-package yasnippet-snippets
  :after yasnippet
  :ensure t)

(use-package smartparens
  :ensure t
  :config
  (show-smartparens-global-mode t)
  (smartparens-global-mode t))

(use-package avy
  :ensure t)
(use-package ace-window
  :ensure t)
(use-package browse-kill-ring
  :ensure t)

(use-package indent-guide
  :ensure t
  :config
  (indent-guide-global-mode t))

(use-package expand-region
  :ensure t)

(use-package hl-todo
  :ensure t
  :config
  (global-hl-todo-mode))
(use-package whitespace
  :ensure t
  :init
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (setq whitespace-line-column 88)
  :config
  (add-hook 'prog-mode-hook 'whitespace-mode))

(use-package bufler
  :ensure t
  :init
  (evil-set-initial-state 'bufler-list-mode 'emacs)
  :config
  (bufler-mode))

;; Terminals
(use-package multi-term
  :ensure t
  :init
  (unless (memq window-system '(mac ns x))
    (setenv "SHELL" "powershell")
    (setq multi-term-program "powershell")
    )
  :config
  (setq multi-term-dedicated-select-after-open-p t)
  )


;; Put temp files in a more sane place
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory ".backup"))))
(setq auto-save-file-name-transforms
      `((".*" ,(concat user-emacs-directory ".backup") t)))
(setq save-place-file (concat user-emacs-directory ".places"))

;; Configuration
(require 'uniquify)
(require 'saveplace)
(setq-default save-place t)

(setq-default line-spacing 2)
(setq-default cursor-type '(bar . 2))
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq ring-bell-function 'ignore)
(setq paragraph-start "\f\\|[ \t]*$\\|[ \t]*[-+*] ")
(setq column-number-mode t)

;; Rendering speedups
(setq bidi-paragraph-direction 'left-to-right)

(setq save-interprogram-paste-before-kill t
      require-final-newline t
      load-prefer-newer t)


(global-hl-line-mode t)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq initial-major-mode 'org-mode)