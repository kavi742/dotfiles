;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)
;;(setq doom-theme 'gruvbox-dark-soft)

;; For current frame
(set-frame-parameter nil 'alpha 97)
;; For all new frames henceforth
(add-to-list 'default-frame-alist '(alpha . 97))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;;settings
(setq-default tab-width 4)
(setq doom-font (font-spec :family "IosevkaTerm Nerd Font Mono" :size 18))
;;(setq Man-notify 'quiet)
(add-to-list 'display-buffer-alist
             '("\\*Man .*\\*" (display-buffer-same-window)))

;; defuns
;; Note taking
(defun my/insert-definition (term)
  "Insert a new definition heading with ID and alias."
  (interactive "sTerm: ")
  (let ((id (org-id-new)))
    (insert (format "** %s :definition:\n:PROPERTIES:\n:ID: %s\n:ROAM_ALIASES: %s\n:END:\n\n" term id term))))

;;keymaps
;; tab
;;(map! :nv "z z" #'+fold/toggle)
;; spc /
(map! :nv "t m" #'treemacs-select-directory)
(map! :leader "t" #'vterm)
(map! :leader "d"  #'my/insert-definition)

;; Make movement keys work like they should
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
                                        ; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!j
(defun my/org-add-current-file-to-agenda ()
  "Add the current file to `org-agenda-files` if it's an Org file."
  (interactive)
  (when (and buffer-file-name
             (string= (file-name-extension buffer-file-name) "org"))
    (add-to-list 'org-agenda-files (file-truename buffer-file-name))
    (message "Added %s to org-agenda-files" buffer-file-name)))

(custom-set-variables
 '(org-directory "~/Notes/"))
(setq org-agenda-files (append '("~/Notes/roam/")))
(after! org
  (setq org-todo-keywords
        '((sequence "TODO(t)" "IN PROGRESS(p)" "|" "DONE(d)" "STUCK(s)" "ABANDONED(a)"))))
(custom-set-faces!
  '(org-level-1 :height 1.3 :weight bold :inherit outline-1)
  '(org-level-2 :height 1.15 :weight bold :inherit outline-2)
  '(org-level-3 :height 1.1 :weight bold :inherit outline-3)
  '(org-todo :foreground "#a6da95" :weight bold)
  '(org-done :foreground "#6e738d" :weight bold)
  )
(use-package org-roam
  :ensure t
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Notes/roam/")
  (org-roam-completion-everwhere t)
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :if-new (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d-W%W>
* TO-DO Today \n
* How I'm Feeling \n
* What I Read Today \n
* What I Did Today \n
* Plan For Tomorrow"))
     ("w" "weekly" entry "* %<%H:%M> %?"
      :if-new (file+head "%<%Y-W%W>.org" "#+title: %<%Y Week %W>
* TO-DO \n
* Monday\n
* Tuesday\n
* Wednesday\n
* Thursday\n
* Friday\n
* Saturday\n
* Sunday\n
* Next Week\n")
      :immediate-finish t
      :unarrowed t)
     ("n" "note" entry "* %?"
      :if-new
      (file+head (lambda ()
                   (expand-file-name
                    (concat (read-string "Filename: ") ".org")
                    default-directory))
                 (lambda ()
                   (let ((fname (file-name-base (buffer-file-name))))
                     (format "#+title: %s\n* General Note\n* Definitions\n* Lesson Questions\n" fname))))))))
;; maccalfw
(use-package! calfw-ical :after calfw)
(use-package! maccalfw :commands maccalfw-open)
(after! widget
  (dolist (face '(widget-field
                  widget-button
                  ical-form-title-field
                  ical-form-field-names
                  ;; add any others you spot
                  ))
    (when (facep face)
      (set-face-attribute face nil :box nil))))


;; ESP32
;;(after! lsp-clangd
;;  (setq lsp-clients-clangd-args '("--background-index" "--clang-tidy" "--completion-style=detailed"))

;; Rust Analyzer Linked Projects
;;(setq lsp-rust-analyzer-linked-projects '("~/Projects/square_app/Cargo.toml"))

;; Astro
;;(use-package! astro-ts-mode
;;  :init
;;  (when (modulep! +lsp)
;;    (add-hook 'astro-ts-mode-hook #'lsp! 'append))
;;  :mode "\\.astro\\'")
;;
;;;;(set-formatter! 'prettier-astro
;;;;  '("npx" "prettier" "--parser=astro"
;;;;    (apheleia-formatters-indent "--use-tabs" "--tab-width" 'astro-ts-mode-indent-offset))
;;;;  :modes '(astro-ts-mode))
;;
;;(use-package! lsp-tailwindcss
;;  :when (modulep! +lsp)
;;  :init
;;  (setq! lsp-tailwindcss-add-on-mode t)
;;  :config
;;  (add-to-list 'lsp-tailwindcss-major-modes 'astro-ts-mode))
;;
;;;; MDX Support
;;(add-to-list 'auto-mode-alist '("\\.\\(mdx\\)$" . markdown-mode))
;;(when (modulep! +lsp)
;;  (add-hook 'markdown-mode-local-vars-hook #'lsp! 'append))
;;
;;
;;(setq treesit-language-source-alist
;;      '((astro "https://github.com/virchau13/tree-sitter-astro")
;;        (css "https://github.com/tree-sitter/tree-sitter-css")
;;        (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))
;;(mapc #'treesit-install-language-grammar '(astro css tsx))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
