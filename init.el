;; NOTE: init.el is now generated from init.org.  Please edit that file
;;       in Emacs and init.el will be generated automatically!

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 120)
(defvar efs/default-variable-font-size 120)

;; Set up low-level stuff so we can install the various packages that make up
;; Corgi. Not super pretty, but you normally don't have to look at it.

;; Install the Straight package manager

(defvar bootstrap-version) 

(let ((install-url "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el")
      (bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer (url-retrieve-synchronously install-url 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install the use-package convenience macro

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(when (not (file-exists-p (expand-file-name "straight/versions/default.el" straight-base-dir)))
  (straight-freeze-versions))

;; Enable the corgi-packages repository so we can install our packages with
;; Straight. This also runs some Corgi initialization code, notably copying over
;; Corgi's version file, so you get the same versions of packages that Corgi was
;; tested with.

(use-package corgi-packages
  :straight (corgi-packages
             :type git
             :host github
             :repo "corgi-emacs/corgi-packages"
             :branch "ox/separate-completion-ui"))

(add-to-list #'straight-recipe-repositories 'corgi-packages)

(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(defun xah-save-all-unsaved ()
  "Save all unsaved files. no ask.
Version 2019-11-05"
  (interactive)
  (save-some-buffers t))

(setq after-focus-change-function 'xah-save-all-unsaved)

(recentf-mode t)

(use-package vundo)

(setq evil-want-C-u-scroll t)

(let ((straight-current-profile 'corgi))
  ;; Change a bunch of Emacs defaults, from disabling the menubar and toolbar,
  ;; to fixing modifier keys on Mac and disabling the system bell.
  (use-package corgi-defaults)

  ;; UI configuration for that Corgi-feel. This sets up a bunch of packages like
  ;; Evil, Smartparens, Projectile (project-aware commands) and Aggressive indent.
  (use-package corgi-editor)

  ;; The few custom commands that we ship with. This includes a few things we
  ;; emulate from Spacemacs, and commands for jumping to the user's init.el
  ;; (this file, with `SPC f e i'), or opening the user's key binding or signals
  ;; file.
  (use-package corgi-commands)

  ;; Extensive setup for a good Clojure experience, including clojure-mode,
  ;; CIDER, and a modeline indicator that shows which REPLs your evaluations go
  ;; to.
  ;; Also contains `corgi/cider-pprint-eval-register', bound to `,,', see
  ;; `set-register' calls below.
  (use-package corgi-clojure)

  (with-eval-after-load 'corgi-clojure (corgi/enable-cider-connection-indicator))
  

  ;; Emacs Lisp config, mainly to have a development experience that feels
  ;; similar to using CIDER and Clojure. (show results in overlay, threading
  ;; refactorings)
  (use-package corgi-emacs-lisp)

  ;; Change the color of the modeline based on the Evil state (e.g. green when
  ;; in insert state)
  (use-package corgi-stateline)

  ;; Package which provides corgi-keys and corgi-signals, the two files that
  ;; define all Corgi bindings, and the default files that Corkey will look for.
  (use-package corgi-bindings)

  ;; Corgi's keybinding system, which builds on top of Evil. See the manual, or
  ;; visit the key binding and signal files (with `SPC f e k', `SPC f e K', `SPC
  ;; f e s' `SPC f e S')
  ;; Put this last here, otherwise keybindings for commands that aren't loaded
  ;; yet won't be active.
  (use-package corkey
    :config 
    (corkey/load-and-watch)
    ;; Automatically pick up keybinding changes
    (corkey-mode 1)))

(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(use-package tree-sitter-langs
  :straight (tree-sitter-langs
             :host github :type git
             :repo "emacs-tree-sitter/tree-sitter-langs")
  :config
  (tree-sitter-load 'org)
  (tree-sitter-require 'org)
  (add-to-list 'tree-sitter-major-mode-language-alist '(org-mode . org))
  (global-tree-sitter-mode))

(use-package lispy)
(defun init-user-symex-conf ()
  (setq lispy-avy-keys (nconc (number-sequence ?a ?x)
                              (number-sequence ?A ?Z)
                              (number-sequence ?1 ?9)
                              '(?z)))
  (setq avy-keys (nconc (number-sequence ?a ?x)
                        (number-sequence ?A ?Z)
                        (number-sequence ?1 ?9)
                        '(?z)))
  (setq symex--user-evil-keyspec
        '(("j" . symex-go-up)
          ("k" . symex-go-down)
          ("s" . symex-go-forward)
          ("n" . symex-traverse-forward)
          ("N" . symex-traverse-forward-skip)
          ("C-w" . symex-wrap-square)
          ("M-w" . symex-wrap-curly)
          ("C-j" . symex-climb-branch)
          ("C-k" . symex-descend-branch)
          ("M-j" . symex-goto-highest)
          ("M-k" . symex-goto-lowest)
          ("." . symex-soar-forward)
          ("," . symex-soar-backward)
          ("r" . symex-replace)
          ("t" . (lambda () (interactive) (evil-set-jump) (lispy-ace-paren)))
          ("T" . (lambda () (interactive) (evil-set-jump) (call-interactively #'avy-goto-symbol-1)))
          ("C-t" . (lambda () (interactive) (signspice-with-mark 'lispy-ace-paren)))
          ("M-t" . (lambda () (interactive) (lispy-ace-paren 2)))
          ("M-T" . (lambda () (interactive) (signspice-with-mark 'lispy-ace-paren 2)))
          ("M-r" . cljr-raise-sexp)
          ("M-R" . lispy-raise-some)
          ("C-e" . signspice-eval-mark)
          ("z" . evil-scroll-line-to-top)
          ("C-u" . signspice-goto-previous-mark)
          ("<tab>" . origami-toggle-node)
          ("<backtab>" . evil-show-marks)
          ("C-d" . cider-pprint-eval-defun-at-point)
          ("C-p" . signspice-pprint-at-point)
          ("C-s-p" . portal.api/open)
          ("C-S-s-p" . portal-copy)
          ("M-p" . signspice-steal-from-ace)))
  (symex-initialize)
  (setq evil-symex-state-cursor '("#884444" box))
  (setq evil-normal-state-cursor 'hollow-rectangle)

  (defun load-symex-branch ()
    "switch active symex branch"
    (interactive)
    (save-excursion
      (let* ((symex-repo-buf (find-file "~/projects/symex.el/.projectile")))
        (with-current-buffer symex-repo-buf
          (magit-branch-checkout (car (completing-read-multiple "select branch: " '("master" "symex-ts-integration"))))))
      (funcall-interactively #'straight-normalize-package (require 'symex))
      (funcall-interactively #'straight-rebuild-package "symex")
      (let* ((symex-features '(symex-transformations
                               symex-transformations-lisp
                               symex-transformations-ts)))
        (dolist (symex-feature symex-features)
          (when (member symex-feature features)
            (unload-feature symex-feature t))))
      ;; trick require to reload symex. (before, I had unloaded all these;
      ;; but somehow one of them unloads a bunch of other features not in the list. not sure why.)
      (setf features (cl-remove-if (lambda (feature) (string-prefix-p "symex" (cl-prin1-to-string feature))) features))
      (require 'symex))))

;; (use-package symex
;;   :straight (symex-main
;;              :type git
;;              :host github
;;              :repo "countvajhula/symex.el")
;;   :config
;;   (init-user-symex-conf))

(use-package symex
  :straight (symex
             :type git
             :host github
             :repo "SignSpice/symex.el"
             :local-repo "~/projects/symex.el")
  :config 
  (init-user-symex-conf))

(use-package combobulate
  :straight '(combobulate
              :host github
              :type git
              :repo "mickeynp/combobulate")
  ;; Ensure `combobulate-mode` is activated when you launch a mode it supports
  :hook ((python-mode . combobulate-mode)
         (js-mode . combobulate-mode)
         (typescript-mode . combobulate-mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-i-jump nil)
  (fset 'evil-visual-update-x-selection 'ignore)
  (setq evil-kill-on-visual-paste nil)
  (setq evil-insert-state-cursor '(bar "green"))
  (setq-default evil-symbol-word-search t)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)

  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-cleverparens
  :after (evil smartparens)
  :commands evil-cleverparens-mode
  :init
  (add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
  (add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
  (setq evil-cleverparens-complete-parens-in-yanked-region t)
  :config
  (setq evil-cleverparens-use-s-and-S nil)
  (evil-define-key '(normal visual) evil-cleverparens-mode-map
    "s" nil
    "S" nil
    "{" nil
    "}" nil
    "[" nil
    "]" nil
    (kbd "<tab>") 'evil-jump-item))

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(column-number-mode)
;; disable line numbers completely
(global-display-line-numbers-mode 0)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package bufler
:straight '(bufler
:type git
:host github
:repo "alphapapa/bufler.el"))

(set-face-attribute 'default nil :font "Iosevka" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Iosevka" :height efs/default-font-size)

;; Set the variable pitch face
;; (set-face-attribute 'variable-pitch nil :font "Times New Roman" :height efs/default-font-size :weight 'regular)
(set-face-attribute 'variable-pitch nil :font "Iosevka" :height efs/default-font-size :weight 'regular)

(use-package command-log-mode)

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package cherry-blossom-theme
  :config
  (load-theme 'cherry-blossom t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 8)))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay .1))

(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  :config
  (define-key vertico-map (kbd "C-j") 'vertico-next)
  (define-key vertico-map (kbd "C-k") 'vertico-previous)
  (define-key vertico-map (kbd "M-h") 'vertico-directory-up)
  
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Example configuration for Consult
(use-package consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-recent-file
   consult--source-project-recent-file
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))

)

(use-package marginalia
  :ensure t
  :config
  (marginalia-mode))

(use-package embark
  :ensure t

  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

;; Consult users will also want the embark-consult package.
(use-package embark-consult
  :ensure t
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package corfu-doc)
(use-package corfu
  :config
  ;; Setup corfu for popup like completion
  (customize-set-variable 'corfu-cycle t) ; Allows cycling through candidates
  (customize-set-variable 'corfu-auto t)  ; Enable auto completion
  (customize-set-variable 'corfu-auto-prefix 2) ; Complete with less prefix keys
  (customize-set-variable 'corfu-auto-delay 0.0) ; No delay for completion
  (customize-set-variable 'corfu-echo-documentation 0.25) ; Echo docs for current completion option

  (global-corfu-mode 1)

  (add-hook 'corfu-mode-hook #'corfu-doc-mode)
  (define-key corfu-map (kbd "M-p") #'corfu-doc-scroll-down)
  (define-key corfu-map (kbd "M-n") #'corfu-doc-scroll-up)
  (define-key corfu-map (kbd "M-d") #'corfu-doc-toggle))

;; Setup Cape for better completion-at-point support and more
(use-package cape
  :config

  ;; Add useful defaults completion sources from cape
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)

  ;; Silence the pcomplete capf, no errors or messages!
  ;; Important for corfu
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

  ;; Ensure that pcomplete does not write to the buffer
  ;; and behaves as a pure `completion-at-point-function'.
  (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify)
  (add-hook 'eshell-mode-hook
            (lambda () (setq-local corfu-quit-at-boundary t
                                   corfu-quit-no-match t
                                   corfu-auto nil)
              (corfu-mode))))

(use-package helpful)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package dogears)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "???"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1))))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ???")

  (setq org-edit-src-content-indentation 0)

  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (require 'org-habit)
  (add-to-list 'org-modules 'org-habit)
  (setq org-habit-graph-column 60)

  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

  (setq org-refile-targets
        '(("Archive.org" :maxlevel . 1)
          ("Tasks.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)

  (setq org-tag-alist
        '((:startgroup)
                                        ; Put mutually exclusive tags here
          (:endgroup)
          ("@errand" . ?E)
          ("@home" . ?H)
          ("@work" . ?W)
          ("agenda" . ?a)
          ("planning" . ?p)
          ("publish" . ?P)
          ("batch" . ?b)
          ("note" . ?n)
          ("idea" . ?i)))

  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))
          ("o" "At the office" tags-todo "@office"
           ((org-agenda-overriding-header "Office")
            (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("???" "???" "???" "???" "???" "???" "???")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)
(setq org-confirm-babel-evaluate nil)

(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(require 'org-tempo)

(use-package denote
  :config
  (setq denote-directory "~/org")

  (setq denote-known-keywords '("journal" "projects" "ideas"
                                "people" "book" "psychology"
                                "thoughts"))
  ;; (setq denote-prompts '(title subdirectory))

  ;; Buttonize all denote links in text buffers
  (add-hook 'find-file-hook #'denote-link-buttonize-buffer)
  (require 'denote-dired)
  (add-hook 'dired-mode-hook #'denote-dired-mode))

;; Fontify file names in Dired

(with-eval-after-load 'org-capture
  (require 'denote-org-capture)
  (add-to-list 'org-capture-templates
               '("n" "New note (with Denote)" plain
                 (file denote-last-path)
                 #'denote-org-capture
                 :no-save t
                 :immediate-finish nil
                 :kill-buffer t
                 :jump-to-captured t)))

(with-eval-after-load 'denote
  (defun my-denote-journal ()
    "Create an entry tagged 'journal' with the date as its title."
    (interactive)
    (denote
     (format-time-string "%A %e %B %Y")  ; format like Tuesday 14 June 2022
     '("journal")
     nil
     "~/Denotes/Journal")

    (insert "* Thoughts\n\n* Tasks\n\n")))

(defun my-denote-journal ()
  "Create an entry tagged 'journal' with the date as its title."
  (interactive)
  (denote
   (format-time-string "%A %e %B %Y")  ; format like Tuesday 14 June 2022
   '("journal")
   nil
   "~/org/")

  (insert "* Thoughts\n\n* Tasks\n\n"))

                                        ; multiple keywords are a list of strings: '("one" "two")

(defun my-denote-journal-with-date (date)
  "Ask for DATE to write a journal entry.
Journal entries are stored in ~/Documents/journal/ and use plain
text for their `denote-file-type'.
Read the doc string of `denote-date' on what a valid DATE input is.
The title of the note is something like Tuesday 17 June 2020,
though you can modify the `format-time-string' specifiers as
described in its doc string."
  (interactive (list (denote--date-prompt)))
  (when-let ((denote-file-type 'text)
             (denote-directory "~/org/")
             (d (denote--valid-date date))
             (id (format-time-string denote--id-format d))
             ((denote--barf-duplicate-id id)))
    (denote--prepare-note
     (format-time-string "%A %e %B %Y" d)
     "journal" nil d id)))

(defun my-denote-journal-for-today ()
  "Write a journal entry for today."
  (interactive)
  (my-denote-journal-with-date
   (format-time-string "%Y-%m-%dT00:00:00"))) ; multiple keywords are a list of strings: '("one" "two"))

(setq org-refile-targets '(("~/org/gtd/gtd.org" :maxlevel . 3)
                           ("~/org/gtd/someday.org" :level . 1)
                           ("~/org/gtd/tickler.org" :maxlevel . 2)))

(setq org-agenda-files '("~/org/gtd/inbox.org"
                         "~/org/gtd/gtd.org"
                         "~/org/gtd/tickler.org"))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline "~/org/gtd/inbox.org" "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline "~/org/gtd/tickler.org" "Tickler")
                               "* %i%? \n %U")))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(setq org-agenda-custom-commands
      '(("d" "Dashboard"
         ((agenda "" ((org-deadline-warning-days 7)))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))
          (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

        ("n" "Next Tasks"
         ((todo "NEXT"
                ((org-agenda-overriding-header "Next Tasks")))))

        ("W" "Work Tasks" tags-todo "+work-email")

        ;; Low-effort next actions
        ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
         ((org-agenda-overriding-header "Low Effort Tasks")
          (org-agenda-max-todos 20)
          (org-agenda-files org-agenda-files)))

        ("w" "Workflow Status"
         ((todo "WAIT"
                ((org-agenda-overriding-header "Waiting on External")
                 (org-agenda-files org-agenda-files)))
          (todo "REVIEW"
                ((org-agenda-overriding-header "In Review")
                 (org-agenda-files org-agenda-files)))
          (todo "PLAN"
                ((org-agenda-overriding-header "In Planning")
                 (org-agenda-todo-list-sublevels nil)
                 (org-agenda-files org-agenda-files)))
          (todo "BACKLOG"
                ((org-agenda-overriding-header "Project Backlog")
                 (org-agenda-todo-list-sublevels nil)
                 (org-agenda-files org-agenda-files)))
          (todo "READY"
                ((org-agenda-overriding-header "Ready for Work")
                 (org-agenda-files org-agenda-files)))
          (todo "ACTIVE"
                ((org-agenda-overriding-header "Active Projects")
                 (org-agenda-files org-agenda-files)))
          (todo "COMPLETED"
                ((org-agenda-overriding-header "Completed Projects")
                 (org-agenda-files org-agenda-files)))
          (todo "CANC"
                ((org-agenda-overriding-header "Cancelled Projects")
                 (org-agenda-files org-agenda-files)))))
        ("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(use-package evil-org)

(use-package org-transclusion
  :config

  )

;; Automatically tangle our Emacs.org config file when we save it
(defun efs/org-babel-tangle-config ()
  (when (or 
         (string-equal buffer-file-name
                       (expand-file-name (concat user-emacs-directory "init.org")))
         (string-equal buffer-file-name
                       (file-truename
                        (expand-file-name (concat user-emacs-directory "init.org")))))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))

(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(defun ox/open-init-org ()
  (interactive)
    (find-file (expand-file-name "init.org" user-emacs-directory)))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  ;; :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(defun ox/refresh-projects-dir ()
  (interactive)
  (projectile-discover-projects-in-directory "~/projects"))

(use-package magit
  :config
;; (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)

(use-package git-link
  :config
  (setq git-link-open-in-browser t
        git-link-use-commit t))

(use-package verb)
(use-package org
  :config (define-key org-mode-map (kbd "C-c C-r") verb-command-map))

(use-package yasnippet-snippets
  :ensure t)
(use-package yasnippet
  :ensure t
  :config (yas-global-mode 1))

(use-package markdown-mode)
(use-package yaml-mode)

;; REPL-driven development for JavaScript, included as an example of how to
;; configure signals, see `user-signal.el' (visit it with `SPC f e s')
(use-package js-comint)

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (customize-set-variable 'js2-basic-offset 2)
  (customize-set-variable 'js2-include-node-externs t))

(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(use-package tide
  :after (company flycheck)
  :config
  (define-key tide-mode-map (kbd "s-b") 'tide-jump-to-definition)
  (define-key tide-mode-map (kbd "s-[") 'tide-jump-back))

(server-start)

(set-register ?k "#_clj (do (require 'kaocha.repl) (kaocha.repl/run))")
(set-register ?K "#_clj (do (require 'kaocha.repl) (kaocha.repl/run-all))")
(set-register ?r "#_clj (do (require 'user :reload) (user/reset))")
(set-register ?g "#_clj (user/go)")
(set-register ?b "#_clj (user/browse)")

(defun ox/open-round-insert ()
  (interactive)
  (paredit-open-round)
  (evil-insert 0))

(show-paren-mode 1)

(defun ox/toggle-parens--replace (pair start end)
  "Replace parens with a new PAIR at START and END in current buffer.
   A helper function for `toggle-parens'."
  (goto-char start)
  (delete-char 1)
  (insert (substring pair 0 1))
  (goto-char end)
  (delete-char 1)
  (insert (substring pair 1 2))
  (goto-char start))

(defun ox/toggle-parens ()
  "Toggle parens () <> [] at cursor.
Turn on `show-paren-mode' to see matching pairs of parentheses
and other characters in buffers. This function then uses the same
function `show-paren-data-function' to find and replace them with
the other pair of brackets.
This function can be easily modified and expanded to replace
other brackets. Currently, mismatch information is ignored and
mismatched parens are changed based on the left one."
  (interactive)
  (let* ((parens (funcall show-paren-data-function))
         (start (if (< (nth 0 parens) (nth 2 parens))
                    (nth 0 parens) (nth 2 parens)))
         (end (if (< (nth 0 parens) (nth 2 parens))
                  (nth 2 parens) (nth 0 parens)))
         (startchar (buffer-substring-no-properties start (1+ start)))
         (mismatch (nth 4 parens)))
    (when parens
      (pcase startchar
        ("(" (ox/toggle-parens--replace "[]" start end))
        ("[" (ox/toggle-parens--replace "{}" start end))
        ("{" (ox/toggle-parens--replace "()" start end))))))

(use-package git-gutter
  :config
  (global-git-gutter-mode +1))

(use-package html-to-hiccup
  :load-path "~/projects/html-to-hiccup")

(use-package caddyfile-mode
  :ensure t
  :mode (("Caddyfile\\'" . caddyfile-mode)
         ("caddy\\.conf\\'" . caddyfile-mode)))

(add-hook 'prog-mode-hook #'hs-minor-mode)
(add-hook 'clojure-mode-hook #'hs-minor-mode)
(add-hook 'emacs-lisp-mode-hook #'hs-minor-mode)

(setq scroll-step            1
      scroll-conservatively  10000)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo))

(use-package zprint-mode)

(use-package web-mode
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  :init
  (setq-default
   indent-tabs-mode nil
   tab-width 2))

(setq nrepl-use-ssh-fallback-for-remote-hosts t)

(use-package clj-refactor
  :after (cider)
  :diminish clj-refactor-mode
  :config
  (setq cljr-cljc-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]"
        cljr-cljs-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]"
        cljr-clojure-test-declaration "[clojure.test :refer [deftest testing is are use-fixtures run-tests join-fixtures]]"
        cljr-eagerly-build-asts-on-startup nil
        cljr-warn-on-eval nil)
  :hook ((clojurex-mode-hook
          clojurescript-mode-hook
          clojurec-mode-hook
          clojure-mode-hook)
         . clj-refactor-mode))

(defun cider-eval-clipboard-handler ()
  (nrepl-make-response-handler
   (current-buffer)
   (lambda (buffer value)
     (with-current-buffer buffer
       (with-temp-buffer
         (insert value)
         (clipboard-kill-region (point-min) (point-max)))))
   (lambda (_buffer out)
     (cider-emit-interactive-eval-output out))
   (lambda (_buffer err)
     (cider-emit-interactive-eval-err-output err))
   '()))

(defun cider-eval-last-sexpr-and-copy-to-clipboard ()
  (interactive)
  (cider-interactive-eval nil
                         (cider-eval-clipboard-handler)
                         (cider-last-sexp 'bounds)
                         (cider--nrepl-pr-request-map)))

(defun jet-pretty ()
  (interactive)
  (shell-command-on-region
   (region-beginning)
   (region-end)
   "jet --pretty --edn-reader-opts '{:default tagged-literal}'"
   (current-buffer)
   t
   "*jet error buffer*"
   t))

(defun ss/wrap-with-spy ()
  (interactive)
  (cider-interactive-eval "(require 'sc.api)")
  (with-undo-amalgamate
    (symex-wrap)
    (insert "sc.api/spy ")
    (symex-mode-interface)
    (indent-for-tab-command)))

(defun ss/rescope-last ()
  (interactive)
  (let ((ns (cider-current-ns t)))
    (cider-nrepl-sync-request:eval "(require 'sc.api)" nil ns)
    (cider-nrepl-sync-request:eval "(defmacro defsc*
                                []
                              `(sc.api/defsc ~(sc.api/last-ep-id)))" nil ns)
    (cider-nrepl-sync-request:eval "(defsc*)" nil ns)))

(defun ss/run-with-args (&optional rescope)
  (interactive)
  (with-undo-amalgamate
    (save-excursion
      (symex-goto-lowest)
      (symex-traverse-forward 2)
      (let ((fn-name (thing-at-point 'sexp t)))
        (symex-go-forward 1)
        (let* ((fn-args (thing-at-point 'sexp t))
               (fn-args-in (read-string (concat fn-name " " fn-args ": "))))
          (cider-nrepl-sync-request:eval (format "(%s %s)" fn-name fn-args-in)
                                         nil
                                         (cider-current-ns t))
          (when rescope (ss/re-scope-last)))))))

(defun ss/run-with-args-and-rescope ()
  (interactive)
  (ss/run-with-args t))

(defun ss/run-and-rescope-dwim* ()
  (interactive)
  (save-excursion
    (with-undo-amalgamate
      (ss/wrap-with-spy)
      (symex-evaluate-definition)
      ;; undo hack, not sure why it doesn't work w/o this.
      (insert ""))))

(defun ss/run-and-rescope-dwim ()
  (interactive)
  (save-excursion
    (ss/run-and-rescope-dwim*)
    (evil-undo-pop)))

(defun ss/instrument-spy* ()
  (interactive)
  (save-excursion
    (with-undo-amalgamate
      (ss/wrap-with-spy)
      (symex-evaluate-definition)
      ;; undo hack, not sure why it doesn't work w/o this.
      (symex-wrap))))

(defun ss/instrument-spy ()
  (interactive)
  (let ((in-symex-mode (or (equal evil-state 'emacslike)
                           (equal evil-state 'normallike))))
    (save-excursion
      (ss/instrument-spy*)
      (evil-undo-pop))
    (when in-symex-mode
      (symex-mode-interface))))

(defun signspice-with-mark (f &rest args)
  (interactive)
  (evil-set-jump)
  (setq signspice-last-jump (point))
  (apply f args))


(defun signspice-yank-and-put-to-mark ()
  (interactive)
  (symex-yank 1)
  (goto-char signspice-last-jump)
  (symex-paste-after 1))


(defun signspice-steal-from-ace ()
  (interactive)
  (let ((starting-point (point)))
    (lispy-ace-paren 2)
    (symex-yank 1)
    (goto-char starting-point)
    (symex-paste-after 1)))


(defun signspice-eval-mark (char)
  (interactive (list (read-char "evaluate mark:")))
  (save-excursion
    (evil-goto-mark char)
    (symex-evaluate 1)))

(defun portal.api/open ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(require 'portal.api) (def p (portal/open {:theme :portal.colors/solarized-light :portal.viewer/default :portal.viewer/tree})) (portal.api/tap)"))

(defun portal-copy ()
  (interactive)
  (kill-new (nrepl-dict-get (cider-nrepl-sync-request:eval "@p") "value"))
  (symex-paste-after 1))

(with-eval-after-load 'cider-mode
        (defun cider-tap (&rest r)
          (cons (concat "(let [__value "
                        (caar r)
                        "] (tap> (if (instance? clojure.lang.IObj __value)
                               (with-meta __value {:portal.viewer/default :portal.viewer/tree
                                                   :theme :portal.colors/solarized-light})
                               __value))
                       __value)")
                (cdar r)))

        (advice-add 'cider-nrepl-request:eval
                    :filter-args #'cider-tap))

(setq signspice-last-jump nil)

(defun signspice-goto-previous-mark ()
  (interactive)
  (when (not signspice-last-jump)
    (setq signspice-last-jump (point)))
  (let ((pos (point))
        (last-pos signspice-last-jump))

    (goto-char last-pos)
    (setq signspice-last-jump pos)))


(defun signspice-pprint-at-point ()
  (interactive)
  (unwind-protect
      (save-excursion
        (forward-sexp)
        (cider-pprint-eval-last-sexp))))

(defun signspice-jsx->clj ()
  (interactive)
  (call-shell-region (point-min) (point-max) "node ~/projects/jsx-to-clojurescript/jsx-to-clojurescript.js --target om --ns n --kebab-tags" t t))


(defun signspice-tsx->jsx ()
  (interactive)
  (call-shell-region (point-min) (point-max) ">> /tmp/temp.tsx; npx detype /tmp/temp.tsx /tmp/temp.jsx; cat /tmp/temp.jsx; rm /tmp/temp.tsx" t t))

;; (use-package popper
;;              :bind (("C-`"   . popper-toggle-latest)
;;                     ("M-`"   . popper-cycle)
;;                     ("C-M-`" . popper-toggle-type))
;;              :init
;;              (setq popper-reference-buffers
;;                    '("\\*Messages\\*"
;;                      "Output\\*$"
;;                      "\\*Async Shell Command\\*"
;;                      help-mode
;;                      compilation-mode
;;                      cider-repl-mode))
;;              (popper-mode +1)
;;              (popper-echo-mode +1))


(use-package git-timemachine)

(defun open-portal-api ()
  (interactive)
  (cider-interactive-eval "(do (require 'portal.api)
                               (add-tap #'portal.api/submit)
                               (def portella (portal.api/open {:portal.viewer/default :portal.viewer/tree}))
                               (portal.api/tap))"))

(defun open-portal-web ()
  (interactive)
  (cider-interactive-eval "(do (require 'portal.web)
                               (add-tap #'portal.api/submit)
                               (def portella (portal.api/open {:theme :portal.colors/solarized-light :portal.viewer/default :portal.viewer/tree}))
                               (portal.api/tap))"))

(defun portal.api/clear ()
  (interactive)
  (cider-nrepl-sync-request:eval
   "(#?(:clj portal.api/clear :cljs portal.web/clear))"))

(defun portal/invoke-portal-command (command-str)
  (cider-nrepl-sync-request:eval
   (concat "(#?(:clj portal.api/eval-str :cljs portal.web/eval-str) \"" command-str "\")")))

(defmacro define-portal-command (command-name)
  (let ((emacs-command-name (intern (format "portal-ui-commands/%s" command-name)))
        (clojure-invocation (format "(portal.ui.commands/%s portal.ui.state/state)" command-name)))
    `(defun ,emacs-command-name ()
       (interactive)
       (portal/invoke-portal-command ,clojure-invocation))))

(define-portal-command select-root)
(define-portal-command select-next)
(define-portal-command select-prev)
(define-portal-command select-parent)
(define-portal-command select-child)
(define-portal-command history-back)
(define-portal-command toggle-expand)
(define-portal-command focus-selected)
(define-portal-command toggle-shell)
(define-portal-command toggle-shell)

(defun portal-copy ()
  (interactive)
  (insert (nrepl-dict-get (cider-nrepl-sync-request:eval "@portella") "value")))

(defun portal-ui-commands/set-viewer (viewer)
  (interactive)
  (portal/invoke-portal-command
   (concat
    "(require '[portal.ui.state :as s])

    (defn set-viewer! [viewer]
      (s/dispatch!
       s/state
       assoc-in
       [:selected-viewers
        (s/get-location
         (s/get-selected-context @s/state))]
       viewer))

    (set-viewer! :portal.viewer/" viewer ")")))

(defun portal-ui-commands/set-tree-viewer ()
  (interactive) (portal-ui-commands/set-viewer "tree"))

(defun portal-ui-commands/set-pprint-viewer ()
  (interactive) (portal-ui-commands/set-viewer "pprint"))

(defun portal-ui-commands/set-inspector-viewer ()
  (interactive) (portal-ui-commands/set-viewer "inspector"))

(with-eval-after-load 'clojure-mode
  (defhydra hydra-portal (clojure-mode-map "C-c C-c")
    "Portal"
    ("r" portal-ui-commands/select-root "Select root")
    ("s" portal-ui-commands/select-next "Select next")
    ("h" portal-ui-commands/select-prev "Select prev")
    ("k" portal-ui-commands/select-parent "Select parent")
    ("j" portal-ui-commands/select-child "Select child")
    ("n" portal-ui-commands/select-child "Select child")
    ("C-h" portal-ui-commands/history-back "History back")
    ("-" portal-ui-commands/focus-selected "Focus selected")
    ("e" portal-ui-commands/toggle-expand "Toggle expand")
    ("i" portal-ui-commands/set-inspector-viewer "Set inspector viewer")
    ("t" portal-ui-commands/set-tree-viewer "Set tree viewer")
    ("p" portal-ui-commands/set-pprint-viewer "Set pprint viewer")
    ("S" portal-ui-commands/toggle-shell "Toggle shell")
    ("c" portal-copy "Copy")
    (";" portal.api/clear "Clear")
    ("q" nil "Exit" :exit t)))

(defun portal-select-first ()
  (interactive)
  (portal-ui-commands/select-root)
  (portal-ui-commands/select-next)
  (hydra-portal/body))

(with-eval-after-load 'cider-mode
  (defun cider-tap (&rest r)
    (cons (concat "(let [__value " (caar r) "]"
                  " (tap> __value)
                     __value)")
          (cdar r)))

  (advice-add 'cider-nrepl-request:eval
              :filter-args #'cider-tap))

(use-package lsp-mode
  :commands lsp
  :config

  ;; Core
  (setq lsp-headerline-breadcrumb-enable nil
        lsp-signature-render-documentation nil
        lsp-signature-function 'lsp-signature-posframe
        lsp-semantic-tokens-enable t
        lsp-idle-delay 0.3
        lsp-use-plists nil
        read-process-output-max (* 1024 1024)
        lsp-enable-folding nil
        lsp-enable-text-document-color nil
        lsp-enable-on-type-formatting nil
        lsp-headerline-breadcrumb-enable nil
        )
  (add-hook 'lsp-after-apply-edits-hook (lambda (&rest _) (save-buffer)))
  ;; probably a better way to disable formatting. Makes everything snail slow enabled for some reason I don't know.
  (defun lsp-format-region (&rest _) nil)  
  ;; Clojure lsp setup
  (let ((clojure-lsp-dev (expand-file-name "~/dev/clojure-lsp/clojure-lsp")))
    (when (file-exists-p clojure-lsp-dev)
      ;; clojure-lsp local development
      (setq lsp-clojure-custom-server-command `("bash" "-c" ,clojure-lsp-dev)
            lsp-completion-no-cache t
            lsp-completion-use-last-result nil))))

(use-package lsp-ui
  :after lsp-mode
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil
        lsp-ui-peek-enable nil))  

(use-package consult-lsp)
