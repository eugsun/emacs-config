;;; init-skeleton.el --- management of new-file skeletons  -*- lexical-binding: t; -*-

(defun my/autoinsert-yas-expand ()
  "Replace text in yasnippet template."
  (yas/expand-snippet (buffer-string) (point-min) (point-max)))

(defun my/convert-resource-name (content)
  (capitalize
  (replace-regexp-in-string
   "\.org" ""
  (replace-regexp-in-string
   "-" " "
   (replace-regexp-in-string "_" " : " content)
   ))))

(use-package autoinsert
  :ensure t
  :custom
  (auto-insert-directory "~/.emacs.d/skeletons/")
  (auto-insert-query nil)
  :config
  (auto-insert-mode t)
  (define-auto-insert '("\\.org\\'" . "Org skeleton") ["org-template.org" my/autoinsert-yas-expand]))
