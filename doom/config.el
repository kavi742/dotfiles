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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!j
(custom-set-variables
 '(org-directory "~/Notes")
 '(org-agenda-files (list org-directory)))

(setq org-directory "~/Notes")
;; org-roam
;;(setq org-directory "~/Notes/000_YR3Winter")

(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Notes/"))
  :config
  (setq org-roam-dailies-directory "~/Notes/Daily")
  )

(after! org
  (setq org-todo-keywords '((sequence "TODO" "IN PROG" "|" "DONE")))
  (setq org-todo-keyword-faces
        '(("TODO" . "#eed49f") ("IN PROG" . "#c6a0f6")
          ("DONE" . (:foreground "#ed8796" :weight bold))))
  (setq org-log-done 'time))

(setq org-roam-dailies-capture-templates
      '(("d" "daily" entry
         "* %<%H:%M> %?"
         :if-new (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y %m %d>
* Today
** Thoughts\n
** What I Did\n
** Media
- [ ] Read
- [ ] TV
- [ ] Movies
- [ ] Sports
- [ ] Games")
         :immediate-finish t
         :unnarrowed t)

        ("w" "weekly" entry "* %<%H:%M> %?"
         :if-new (file+head "~/Notes/Weekly/%<%Y-W%W>.org" "#+title: %<%Y Week %W>
* TO-DO\n
* Monday\n
* Tuesday\n
* Wednesday\n
* Thursday\n
* Friday\n
* Saturday\n
* Sunday\n
* Next Week Reminders\n
")
         :immediate-finish t
         :unnarrowed t)))

;;settings
(setq-default tab-width 4)

;;keymaps
;; tab
;;(map! :nv "z z" #'+fold/toggle)
;; spc /
(map! :nv "r g" #'consult-ripgrep)
(map! :nv "SPC o c" #'cfw:open-org-calendar)
(use-package! calfw
  :defer t
  :config
  (map! :map cfw:calendar-mode-map
        :m "W" #'cfw:change-view-two-weeks))
(setq x-super-keysym 'meta)

(setq doom-font (font-spec :family "Iosevka" :size 22))
;;(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 16))
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "librewolf")

(use-package! org-caldav
  :init
  (defun org-caldav-sync-at-close ()
    (org-caldav-sync)
    (save-some-buffers))
  (defvar org-caldav-sync-timer nil
    "Timer that `org-caldav-push-timer' used to reschedule itself, or nil.")
  (defun org-caldav-sync-with-delay (secs)
    (when org-caldav-sync-timer
      (cancel-timer org-caldav-sync-timer))
    (setq org-caldav-sync-timer
	  (run-with-idle-timer
	   (* 1 secs) nil 'org-caldav-sync)))
  :after org
  ;;https://www.reddit.com/r/orgmode/comments/8rl8ep/making_orgcaldav_useable/
  :config
  (setq org-caldav-url "https://nextcloud.nucplex.duckdns.org/remote.php/dav/calendars/kavi741"
        org-caldav-calendar-id "schedule"
        org-caldav-inbox "~/Notes/schedule.org"
        org-caldav-files '("~/Notes/000_YR3Winter/YR3Winter.org")
        org-caldav-sync-changes-to-org 'all
        ;;org-icalendar-alarm-time 20
        org-icalendar-use-deadline '(event-if-not-todo todo-due)
        org-icalendar-use-scheduled '(event-if-not-todo)
        ;;org-icalendar-include-todo 'all
        ;;org-caldav-sync-todo t
        org-icalendar-categories '(local-tags)
        org-icalendar-timezone "America/Toronto"
        org-caldav-save-directory "~/Notes/org-caldav/"
        )
  ;;for login caching
  (setq plstore-cache-passphrase-for-symmetric-encryption t)
  (setq auth-sources '((:source "~/.authinfo" "~/.authinfo.gpg")))
  ;;auto sync calendar every 10 minutes (600 seconds)
  (add-hook 'after-save-hook
            (lambda ()
              (when (eq major-mode 'org-mode)
        	(org-caldav-sync-with-delay 600)))))
;;Add the close emacs hook
;;(add-hook 'kill-emacs-hook 'org-caldav-sync-at-close))
(defun my-open-calendar ()
  (interactive)
  (cfw:open-calendar-buffer
   :contents-sources
   (list
    (cfw:org-create-source "Green")  ; org-agenda source
    (cfw:ical-create-source "nextcloud" "https://nextcloud.nucplex.duckdns.org/remote.php/dav/calendars/kavi741/Schedule" "IndianRed")
    )))


(setq calendar-day-name-array  ["Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday"])
(setq calendar-week-start-day 0)

;; Make movement keys work like they should
(define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
(define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
                                        ; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

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
