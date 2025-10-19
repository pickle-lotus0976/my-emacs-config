;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Suppress Warnings During Startup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Suppress native compilation warnings during startup only
;; We'll enable them after startup to catch real errors
(setq native-comp-async-report-warnings-errors nil)
(setq byte-compile-warnings '(not obsolete free-vars unresolved))

;; Suppress the `cl` deprecation warning (it's from old packages, not our fault)
(setq byte-compile-warnings '(cl-functions))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Package Management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Initialize the package system
(require 'package)

;; Add MELPA repository
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Load and activate installed packages
(package-initialize)

;; Refresh package list if it doesn't exist
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap 'use-package'
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

;; Automatically install missing packages
(setq use-package-always-ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Performance Optimization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Increase garbage collection threshold during startup
(setq gc-cons-threshold (* 50 1000 1000))

;; Reduce frequency of UI updates
(setq idle-update-delay 1.0)

;; Increase amount of data Emacs reads from processes
(setq read-process-output-max (* 1024 1024)) ; 1 MB

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Dashboard - Welcome Screen
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package dashboard
  :config
  ;; Dashboard settings
  (setq dashboard-banner-logo-title "Welcome to Emacs")
  (setq dashboard-startup-banner 'logo)  ; Emacs logo

  ;; Center content
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)

  ;; Show icons (simple, no fancy fonts needed)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)

  ;; What to show (keep it simple for speed)
  (setq dashboard-items '((recents  . 3)
                         (bookmarks . 5)
                         (agenda . 5)))

  ;; Show loading time
  (setq dashboard-set-init-info t)

  ;; A simple but cool dashboard icon
  (setq dashboard-footer-icon "⚡")

  ;; Activate dashboard
  (dashboard-setup-startup-hook))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Font - JetBrains Mono Nerd Font
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (member "JetBrainsMono Nerd Font" (font-family-list))
  (set-face-attribute 'default nil
                      :font "JetBrainsMono Nerd Font"
                      :height 140)
  (set-face-attribute 'fixed-pitch nil
                      :font "JetBrainsMono Nerd Font"
                      :height 140))

(unless (member "JetBrainsMono Nerd Font" (font-family-list))
  (message "Warning: JetBrainsMono Nerd Font not found. Using default font."))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Icons - All The Icons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package all-the-icons
  :if (display-graphic-p))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Some basic UI and Editor Behavior settings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq inhibit-startup-screen t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(show-paren-mode 1)
(setq show-paren-delay 0)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(size-indication-mode 1)
(global-font-lock-mode 1)
(global-hl-line-mode 1)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq make-backup-files t)
(setq create-lockfiles nil)
(setq scroll-conservatively 100)
(setq scroll-margin 3)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(global-auto-revert-mode 1)
(setq-default show-trailing-whitespace t)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Theme - Catppuccin Mocha (Best theme in the world btw)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package catppuccin-theme
  :config
  (setq catppuccin-flavor 'mocha)
  (load-theme 'catppuccin :no-confirm))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 3)
  (setq doom-modeline-icon t)
  (setq doom-modeline-major-mode-icon t)
  (setq doom-modeline-major-mode-color-icon t)
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Company - Auto-completion Framework
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package company
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 2)
  (setq company-show-quick-access t)
  (setq company-selection-wrap-around t)
  (setq company-dabbrev-downcase nil)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection)
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Flycheck - On-the-fly Syntax Checking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled))
  (setq flycheck-idle-change-delay 0.5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; LSP Mode - Language Server Protocol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-idle-delay 0.5)
  (setq lsp-log-io nil)
  (setq lsp-file-watch-threshold 2000)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-headerline-breadcrumb-enable t)
  (setq lsp-modeline-diagnostics-enable t)

  ;; Allow LSP to work outside projects (for learning/testing)
  (setq lsp-auto-guess-root t)

  ;; Don't ask about project roots every time
  (setq lsp-auto-configure t)

  :hook
  ((c-mode c++-mode) . lsp-deferred)
  (python-mode . lsp-deferred)
  (sh-mode . lsp-deferred))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-peek-enable t)
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-position 'at-point)
  (setq lsp-ui-doc-delay 0.5)
  :bind (:map lsp-ui-mode-map
              ("C-c l d" . lsp-ui-doc-show)
              ("C-c l p" . lsp-ui-peek-find-definitions)
              ("C-c l r" . lsp-ui-peek-find-references)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; C/C++ Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq c-default-style "linux")
(setq c-basic-offset 4)

(add-hook 'c++-mode-hook
          (lambda ()
            (setq flycheck-gcc-language-standard "c++17")
            (setq flycheck-clang-language-standard "c++17")))

(add-hook 'c-mode-hook
          (lambda ()
            (setq flycheck-gcc-language-standard "c99")
            (setq flycheck-clang-language-standard "c99")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Python Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq python-indent-offset 4)
(setq python-indent-guess-indent-offset nil)
(setq python-shell-interpreter "python3")

(use-package pyvenv
  :config
  (add-hook 'python-mode-hook
            (lambda ()
              (let ((venv-dir (locate-dominating-file default-directory ".venv")))
                (when venv-dir
                  (pyvenv-activate (expand-file-name ".venv" venv-dir)))))))

(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp-deferred))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Perl Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defalias 'perl-mode 'cperl-mode)

(setq cperl-indent-level 4)
(setq cperl-close-paren-offset -4)
(setq cperl-continued-statement-offset 4)
(setq cperl-indent-parens-as-block t)
(setq cperl-tab-always-indent t)

(add-hook 'cperl-mode-hook
          (lambda ()
            (setq show-trailing-whitespace nil)))

(add-hook 'cperl-mode-hook
          (lambda ()
            (set (make-local-variable 'compile-command)
                 (concat "perl -c " (buffer-file-name)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Bash/Shell Script Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq sh-basic-offset 4)
(setq sh-indentation 4)
(setq sh-shell-file "/bin/bash")

(add-hook 'sh-mode-hook
          (lambda ()
            (sh-set-shell
             (cond
              ((string-match "bash" (buffer-string)) "bash")
              ((string-match "zsh" (buffer-string)) "zsh")
              (t "sh")))))

(add-hook 'sh-mode-hook 'flycheck-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emacs Lisp Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (company-mode 1)
            (eldoc-mode 1)
            (setq eldoc-idle-delay 0.1)))

(define-key emacs-lisp-mode-map (kbd "C-c C-e") 'eval-last-sexp)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File Explorer - Neotree with Icons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package neotree
  :bind (("<f8>" . neotree-toggle))
  :config
  (setq neo-show-hidden-files t)
  (setq neo-smart-open t)
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow))
  (setq neo-autorefresh t)
  (setq neo-window-width 30)
  (setq neo-window-fixed-size nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; File Explorer Alternative - Dired with Icons
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'dired-x)
(setq dired-listing-switches "-alh")
(setq dired-dwim-target t)
(add-hook 'dired-mode-hook 'dired-hide-details-mode)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Terminal Emulator (v-term)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package vterm
  :bind ("C-c t" . vterm)
  :config
  (setq vterm-max-scrollback 10000)
  (setq vterm-shell "/bin/bash")
  (setq vterm-term-environment-variable "xterm-256color"))

(use-package multi-term
  :bind ("C-c T" . multi-term)
  :config
  (setq multi-term-program "/bin/bash"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Debugger - GDB Integration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq gdb-many-windows t)
(setq gdb-show-main t)
(setq gdb-use-separate-io-buffer t)

(use-package realgud)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Project Management (Projectile Configuration)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (setq projectile-completion-system 'default)
  (setq projectile-enable-caching t)
  (setq projectile-cache-file
        (expand-file-name "projectile.cache" user-emacs-directory)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Which-Key Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package which-key
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.5))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Magit - Git Interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit - The best Git interface in the world!
;; Press C-x g to open Magit status buffer
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-x M-g" . magit-dispatch))
  :config
  ;; Show word-level differences in diff
  (setq magit-diff-refine-hunk 'all)

  ;; Automatically refresh Magit buffers
  (setq magit-refresh-status-buffer t)

  ;; Show commit message in separate window
  (setq magit-commit-show-diff t))

;; Show git status in the fringe (left side of buffer)
(use-package diff-hl
  :config
  (global-diff-hl-mode)
  (diff-hl-flydiff-mode)

  ;; Integrate with Magit
  (add-hook 'magit-pre-refresh-hook 'diff-hl-magit-pre-refresh)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; PlatformIO Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; PlatformIO mode for embedded development
;; Supports Arduino, ESP32, STM32, and 1000+ boards
(use-package platformio-mode
  :hook ((c-mode c++-mode) . platformio-conditionally-enable)
  :config
  ;; Enable PlatformIO minor mode only in PIO projects
  (defun platformio-conditionally-enable ()
    "Enable PlatformIO mode only in PIO projects."
    (when (or (locate-dominating-file default-directory "platformio.ini")
              (locate-dominating-file default-directory ".pio"))
      (platformio-mode)))

  ;; Keybindings (when in PlatformIO mode)
  ;; C-c i m - Menu of PlatformIO commands
  ;; C-c i b - Build project
  ;; C-c i u - Upload to board
  ;; C-c i c - Clean project
  ;; C-c i t - Run tests
  )

;; Company mode integration for PlatformIO
;; This provides better auto-completion for Arduino libraries
(use-package company-arduino
  :after company
  :config
  (add-to-list 'company-backends 'company-arduino))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emcas Org Mode Configuraton
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Setup use-package just in case everything isn't already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Enable use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(use-package org
  :pin gnu)

;; Must do this so the agenda knows where to look for my files
(setq org-agenda-files '("~/org"))

;; When a TODO is set to a done state, record a timestamp
(setq org-log-done 'time)

;; Follow the links
(setq org-return-follows-link  t)

;; Associate all org files with org mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; Make the indentation look nicer
(add-hook 'org-mode-hook 'org-indent-mode)

;; Remap the change priority keys to use the UP or DOWN key
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Shortcuts for storing links, viewing the agenda, and starting a capture
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)

;; When you want to change the level of an org item, use SMR
(define-key org-mode-map (kbd "C-c C-g C-r") 'org-shiftmetaright)

;; Hide the markers so you just see bold text as BOLD-TEXT and not *BOLD-TEXT*
(setq org-hide-emphasis-markers t)

;; Wrap the lines in org mode so that things are easier to read
(add-hook 'org-mode-hook 'visual-line-mode)

(let* ((variable-tuple '(:font "JetBrainsMono Nerd Font"))
       (base-font-color     (face-foreground 'default nil 'default))
       (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

  (custom-theme-set-faces
   'user
   `(org-level-8 ((t (,@headline ,@variable-tuple))))
   `(org-level-7 ((t (,@headline ,@variable-tuple))))
   `(org-level-6 ((t (,@headline ,@variable-tuple))))
   `(org-level-5 ((t (,@headline ,@variable-tuple))))
   `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
   `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.2))))
   `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.3))))
   `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.5))))
   `(org-document-title ((t (,@headline ,@variable-tuple :height 1.6 :underline nil))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; mu4e - Email Client Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Your identity
(setq user-mail-address "sahashubhrakamal@gmail.com"
      user-full-name "Shubhrakamal Saha")

(setq mail-host-address "gmail.com")

;; mu4e configuration with encrypted password
(use-package mu4e
  :ensure nil  ; Installed with system mu4 package
  :bind ("C-c m" . mu4e)
  :config
  ;; Paths
  (setq mu4e-maildir "~/Mail")

  ;; Sync command - update every 5 minutes
  (setq mu4e-get-mail-command "mbsync -a")
  (setq mu4e-update-interval 300)

  ;; IMPORTANT: Don't ask for confirmation on quit
  (setq mu4e-confirm-quit nil)

  ;; Gmail folder structure
  (setq mu4e-drafts-folder "/gmail/drafts")
  (setq mu4e-sent-folder   "/gmail/sent")
  (setq mu4e-trash-folder  "/gmail/trash")
  (setq mu4e-refile-folder "/gmail/archive")

  ;; Gmail automatically saves sent messages
  (setq mu4e-sent-messages-behavior 'delete)

  ;; SMTP for sending mail (uses encrypted password from .authinfo.gpg)
  (require 'smtpmail)
  (setq message-send-mail-function 'smtpmail-send-it
        smtpmail-smtp-server "smtp.gmail.com"
        smtpmail-smtp-service 587
        smtpmail-stream-type 'starttls
        smtpmail-auth-source-explicit t)

  ;; Use encrypted authinfo
  (setq auth-sources '("~/.authinfo.gpg"))

  ;; Better viewing
  (setq mu4e-view-show-images t)
  (setq mu4e-view-show-addresses t)
  (setq mu4e-view-prefer-html t)

  ;; HTML rendering
  (setq mu4e-html2text-command "w3m -T text/html")

  ;; Attachments
  (setq mu4e-attachment-dir "~/Downloads")

  ;; Headers in main view
  (setq mu4e-headers-fields
        '((:human-date    .  12)
          (:flags         .   6)
          (:from-or-to    .  22)
          (:subject       .  nil)))

  ;; Shortcuts for folders
  (setq mu4e-maildir-shortcuts
        '((:maildir "/gmail/INBOX" :key ?i)
          (:maildir "/gmail/sent"  :key ?s)
          (:maildir "/gmail/trash" :key ?t)))

  ;; Format for composing
  (setq mu4e-compose-format-flowed t)

  ;; Don't keep message buffers around
  (setq message-kill-buffer-on-exit t))

;; HTML email viewing
(use-package w3m
  :defer t)

;; Optional: Send org-mode formatted emails
(use-package org-mime
  :after mu4e
  :config
  (setq org-mime-export-options '(:section-numbers nil
                                  :with-author nil
                                  :with-toc nil)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cleanup and Maintainence
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Limit backup files (already configured, but verify)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions t)  ; Auto-delete old backup versions
(setq kept-new-versions 6)    ; Keep 6 newest versions
(setq kept-old-versions 2)    ; Keep 2 oldest versions
(setq version-control t)      ; Use version numbers for backups

;; Clean up old auto-save files
(setq delete-auto-save-files t)

;; Don't clutter directories with lock files
(setq create-lockfiles nil)  ; Already in your config

;; Limit recentf (recent files list)
(setq recentf-max-saved-items 50)
(setq recentf-max-menu-items 15)

;; Clean up old native compilation cache
(setq native-comp-eln-load-path
      (list (expand-file-name "eln-cache" user-emacs-directory)))

;; Limit message log
(setq message-log-max 1000)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Restore Performance After Startup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))
            ;; Re-enable warnings after startup
            (setq native-comp-async-report-warnings-errors 'silent)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; End of Configuration
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(message "Emacs configuration loaded successfully!")

;; DO NOT TOUCH THESE SETTINGS!

;; Custom settings (automatically added by Emacs)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(comment-tags org-super-agenda magit which-key projectile realgud multi-term vterm all-the-icons-dired neotree lsp-pyright pyvenv lsp-ui lsp-mode flycheck company catppuccin-theme doom-modeline all-the-icons)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-document-title ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font" :height 1.6 :underline nil))))
 '(org-level-1 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font" :height 1.5))))
 '(org-level-2 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font" :height 1.3))))
 '(org-level-3 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font" :height 1.2))))
 '(org-level-4 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font" :height 1.1))))
 '(org-level-5 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font"))))
 '(org-level-6 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font"))))
 '(org-level-7 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font"))))
 '(org-level-8 ((t (:inherit default :weight bold :foreground "#cdd6f4" :font "JetBrainsMono Nerd Font")))))
