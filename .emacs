;; -*- mode: emacs-lisp; indent-tabs-mode: nil -*-
;;.emacs file for Nelson Elhage (nelhage@nelhage.com)
;; Requires emacs 24 or higher

(add-to-list 'load-path "~/.elisp")
(cd "~/.elisp")
(load "~/.elisp/subdirs.el")
(cd "~")

(when (and (file-exists-p ".emacs.d/elpa")
           (not (file-symlink-p ".emacs.d/elpa")))
  (rename-file ".emacs.d/elpa" ".emacs.d/elpa.bak"))
(unless (file-exists-p ".emacs.d/elpa")
  (make-symbolic-link "../.elisp/elpa" ".emacs.d/elpa"))

(require 'package)
(add-to-list 'package-archives
     '("marmalade" .
       "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

(setq exec-path-from-shell-variables '("PATH" "MANPATH" "GOROOT" "GOPATH" "TEXINPUTS"))
(exec-path-from-shell-initialize)

(require 'uniquify)
(require 'utils)
(require 'structured)
(require 'dirvars)
(require 'subr-x)

(require 'helm-config)
(helm-mode 1)
(require 'helm-gtags)
;(autoload 'gtags-mode "gtags" "" t)
(helm-gtags-mode t)
;(gtags-mode 1)
(add-hook 'helm-gtags-mode-hook
'(lambda ()
(local-set-key (kbd "M-.") 'helm-gtags-find-tag)
(local-set-key (kbd "M-/") 'helm-gtags-find-rtag)
(local-set-key (kbd "M-s") 'helm-gtags-find-symbol)
(local-set-key (kbd "M-,") 'helm-gtags-pop-stack)
(local-set-key (kbd "C-c C-f") 'helm-gtags-find-files)))

(require 'highlight-symbol)
(global-set-key [(f3)] 'highlight-symbol-at-point)
(global-set-key [(control .)] 'highlight-symbol-next)
(global-set-key [(control \,)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-query-replace)

(tool-bar-mode -1)

;; Show the current function name in the header line
(which-function-mode)
(setq-default header-line-format
              '((which-func-mode ("" which-func-format))))
(setq mode-line-misc-info
            ;; We remove Which Function Mode from the mode line, because it's mostly
            ;; invisible here anyway.
            (assq-delete-all 'which-func-mode mode-line-misc-info))

;(setq c-default-style "linux")
(scroll-bar-mode -1)

(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-set-key (kbd "C-c <left>")  'windmove-left)
(global-set-key (kbd "C-c <right>") 'windmove-right)
(global-set-key (kbd "C-c <up>")    'windmove-up)
(global-set-key (kbd "C-c <down>")  'windmove-down)

;;Global key bindings
(global-set-key (kbd "<deletechar>") 'backward-delete-char)
(global-set-key (kbd "ESC <deletechar>") 'backward-kill-word)
(global-set-key (kbd "C-z") nil)
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-m" 'magic-mode-newline-and-indent)
(global-set-key "\M-k" 'kill-word)
(global-set-key "\C-cc" 'compile)
(global-set-key "\C-a" 'beginning-of-line-dwim)
(global-set-key "\C-co" 'other-window)
(global-set-key [f5] 'call-last-kbd-macro)
(global-set-key (kbd "TAB") 'indent-and-complete-symbol-generic)
(global-set-key (kbd "M-r") 're-search-backward)
(global-set-key (kbd "M-s") 're-search-forward)
; (global-set-key [up] 'increment-number-at-point)
; (global-set-key [down] 'decrement-number-at-point)
(global-set-key (kbd "C-x C-c") 'server-edit)

(setq window-number-prefix "\C-c")
(require 'window-number)
(window-number-mode 1)
(require 'popwin)

(let ((tmp nil))
  (mapc (lambda (e)
                (if (not (or (and (consp e) (or (eq (car e) 'grep-mode)
                                                (eq (car e) 'occur-mode)
                                                (eq (car e) 'compilation-mode)))
                             (equal e "*vc-diff*")))
                    (setq tmp (cons e tmp))))
        popwin:special-display-config)
  (setq popwin:special-display-config tmp))

(global-company-mode 1)

(custom-set-faces
 '(company-preview
   ((t (:foreground "darkgray" :underline t))))
 '(company-preview-common
   ((t (:inherit company-preview))))
 '(company-tooltip
   ((t (:background "lightgray" :foreground "black"))))
 '(company-tooltip-selection
   ((t (:background "steelblue" :foreground "white"))))
 '(company-tooltip-common
   ((((type x)) (:inherit company-tooltip :weight bold))
    (t (:inherit company-tooltip))))
 '(company-tooltip-common-selection
   ((((type x)) (:inherit company-tooltip-selection :weight bold))
    (t (:inherit company-tooltip-selection)))))

(setq company-tooltip-limit 20
      company-minimum-prefix-length 3
      company-idle-delay .3
      company-echo-delay 0
      company-begin-commands '(self-insert-command))

(setq display-time-24hr-format t)

; (global-set-key (kbd "C-x 4 C-f") 'window-number-find-file)
; (global-set-key (kbd "C-x 4 f") 'window-number-find-file)

(setq lpr-switches '("-h"))
(setq ps-left-header '(ps-get-buffer-name user-full-name))
(setq woman-use-own-frame nil)
(setq split-height-threshold nil)

(fset 'rm 'delete-file)
(fset 'mv 'rename-file)
(fset 'cp 'copy-file)
(fset 'mkdir 'make-directory)
(fset 'rmdir 'delete-directory)

(condition-case nil
    (progn
      ;; Apparently I'm not supposed to set this globally, but if you're not
      ;; going to tell me why, too bad.
      (setq epa-armor t)
      (require 'epa-file)
      (epa-file-enable))
  ('file-error . nil))

(autoload 'nethack "nethack" "Play Nethack." t)
(setq nethack-program "/usr/games/nethack-lisp")

;; DocView / Image Viewer
(eval-after-load 'doc-view
  '(progn
     (define-key doc-view-mode-map (kbd "C-v") 'doc-view-scroll-up-or-next-page)
     (define-key doc-view-mode-map (kbd "M-v") 'doc-view-scroll-down-or-previous-page)
     (define-key doc-view-mode-map (kbd "C-e") 'image-eol)
     (define-key doc-view-mode-map (kbd "C-a") 'image-bol)
     (define-key doc-view-mode-map (kbd "C-c t") 'doc-view-open-text)))

(eval-after-load 'compile
  '(progn
     (let ((ent (assq 'gcc-include compilation-error-regexp-alist-alist)))
       (when ent
         (setcar (cdr ent) "^\\(?:In file included\\|                \\) from \\(.+?\\):\\([0-9]+\\)\\(:[0-9]+\\)?\\(?:\\(:\\)\\|\\(,\\)\\)?")
         (setcdr (cdr ent) (list 1 2 nil '(4 . 5)))))))

(add-hook 'after-init-hook #'global-flycheck-mode)
(setq-default flycheck-disabled-checkers
              '(ruby-rubylint ruby ruby-jruby python-flake8 python-pylint puppet-lint))
(setq-default flycheck-rubocoprc (expand-file-name "~/.rubocop.yml"))
(setq-default flycheck-rubocop-lint-only nil)


(defun strip-lf ()
  (interactive)
  (save-excursion
    (replace-string "" "" nil (point-min) (point-max))))

(defun indent-and-complete-symbol-generic ()
  "Indent the current line and perform symbol completion using
  `complete-symbol' First indent the line, and if
  indenting doesn't move point, complete the symbol at point."
  (interactive)
  (let ((pt (point)))
    (funcall indent-line-function)
    (when (and (= pt (point))
               (save-excursion (re-search-backward "[^() \n\t\r]+\\=" nil t))
               (or (looking-at "\\Sw")
                   (= (point) (point-max))))
      (complete-symbol nil))))

;;Set up fonts and colors
(when (fboundp 'global-font-lock-mode)
  (setq font-lock-face-attributes
        '((font-lock-comment-face  "OrangeRed")
          (font-lock-function-name-face "#5555AA")
          (font-lock-keyword-face "Cyan1")
          (font-lock-string-face "orange")))
  (require 'font-lock)
  (require 'whitespace)
  (require 'jit-lock)
  (when (facep 'whitespace-tab)
    (set-face-background 'whitespace-tab "#111133"))
  (setq whitespace-style '(face trailing tabs))
  (global-whitespace-mode 1)
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  (setq font-lock-maximum-decoration t
        font-lock-global-modes '(not magit-mode w3m-mode term-mode)
        font-lock-support-mode 'jit-lock-mode)
  (global-font-lock-mode 1))

(defun safe-set-face-attribute (face frame &rest args)
  (when (facep face)
    (apply 'set-face-attribute face frame args)))

(eval-after-load 'diff-mode
  '(progn
     (safe-set-face-attribute 'diff-refine-change nil :background "gray20")
     (safe-set-face-attribute 'diff-file-header   nil :background "gray40")
     (safe-set-face-attribute 'diff-removed-face  nil :foreground "red")
     (safe-set-face-attribute 'diff-added-face    nil :foreground "green")))

(defvar try-fonts
  (list
   "-*-Source Code Pro-normal-normal-normal-*-11-*-*-*-m-0-iso10646-1"
   "Mono-11"
   "-adobe-courier-medium-r-*-*-12-*-*-*-*-70-iso8859-1"))
(defvar default-font ""
  "The default font")

(when window-system
  (let ((try try-fonts))
    (while (and try (not (font-info (car try))))
      (setq try (cdr try)))
    (setq default-font (car try)))
  (set-face-foreground 'which-func "green")
  (set-face-background 'which-func "black")
  (setq default-frame-alist
        `((menu-bar-lines . 0)
          (font . ,default-font)
          (foreground-color . "#AAA")
          (background-color . "black")
          (background-mode . 'dark)
          (vertical-scroll-bars . nil)
          (tool-bar-lines . 0))))

(defun set-projector-faces ()
  (interactive)
  (set-face-attribute 'default nil
                      :height 150
                      :foreground "black"
                      :background "white")
  (set-face-attribute 'font-lock-comment-face nil
                      :foreground "dark green")
  (set-face-attribute 'font-lock-keyword-face nil
                      :foreground "blue"
                      :weight 'bold)
  (set-face-attribute 'font-lock-string-face nil
                      :foreground "dark red"))

(defun set-normal-faces ()
  (interactive)
  (set-face-attribute 'default nil
                      :foreground "#AAA"
                      :background "black")
  (set-face-attribute 'font-lock-comment-face nil
                      :foreground "OrangeRed")
  (set-face-attribute 'font-lock-keyword-face nil
                      :foreground "Cyan1"
                      :weight 'normal)
  (set-face-attribute 'font-lock-string-face nil
                      :foreground "orange")
  (set-frame-font default-font t))

(defun safe-funcall (func &rest args)
  "Call FUNC on ARGS if and only if FUNC is defined as a function."
  (when (fboundp func) (apply func args)))

(setq inhibit-startup-message t)

(safe-funcall 'set-scroll-bar-mode nil)
(safe-funcall 'tool-bar-mode -1)
(safe-funcall 'auto-compression-mode 1)
(safe-funcall 'column-number-mode 1)
(safe-funcall 'fringe-mode '(0 . nil))
(safe-funcall 'menu-bar-mode 0)
; (safe-funcall 'display-time-mode)
; (safe-funcall 'display-battery-mode)

(transient-mark-mode 0)

(setq c-basic-offset 4
      mouse-wheel-follow-mouse nil
      mouse-wheel-progressive-speed nil
      confirm-kill-emacs 'yes-or-no-p
      x-select-enable-clipboard t
      uniquify-buffer-name-style 'post-forward-angle-brackets
      outline-regexp "\\s *\\*+"
      comint-prompt-read-only t
      diff-switches "-u"
      compile-command "find-makefile"
      pop-up-windows nil
      save-interprogram-paste-before-kill t
      Man-width 80)
(eval-after-load 'grep
  '(progn
     (grep-apply-setting 'grep-use-null-device nil)
     (grep-apply-setting 'grep-command "gr -nH -Ee ")

     (defun grep-default-command ()
       grep-command)))

(defun chomp (str)
  "Chomp leading and tailing whitespace from STR."
  (while (string-match "\\`\n+\\|^\\s-+\\|\\s-+$\\|\n+\\'"
                       str)
    (setq str (replace-match "" t t str)))
  str)

(eval-after-load 'calc
  '(progn
     (defadvice calc (around calc-pop-up-windows)
       (let ((pop-up-windows t))
         ad-do-it))
     (ad-activate 'calc)
     (define-key calc-mode-map (kbd "C-/") 'calc-undo)))

(setq-default tab-width 8
              truncate-lines t
              truncate-partial-width-windows nil
              indent-tabs-mode nil)

(setq tramp-default-method "ssh")

(when (fboundp 'show-paren-mode)
  (setq show-paren-delay 0)
  (show-paren-mode 1))

(require 'shell)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook 'my-shell-mode-hook)

(defun inferior-process-cwd (buffer)
  (let ((proc (get-buffer-process buffer)))
    (if proc
        (let ((pid (process-id proc)))
          (file-symlink-p (concat "/proc/" (int-to-string pid) "/cwd"))))))

(defun shell-mode-chdir (line)
  (let ((wd (inferior-process-cwd (current-buffer))))
    (when wd (cd wd)))
  line)

(defun my-shell-mode-hook ()
  (shell-dirtrack-mode 0)
  (add-hook 'comint-preoutput-filter-functions 'shell-mode-chdir))

(defun named-shell (name directory)
  (interactive "MShell name: \nDIn directory: ")
  (switch-to-buffer (concat "*" name "*"))
  (cd directory)
  (shell (current-buffer)))

(defun filter-trailing-whitespace (string)
  (replace-regexp-in-string "\[ \t\]+$" "" string))
(add-hook 'term-mode-hook 'my-term-mode-hook)
(defun my-term-mode-hook ()
  (add-hook 'buffer-substring-filters 'filter-trailing-whitespace))

(defun maybe-browse-url-at-point ()
  (interactive)
  (let ((url (thing-at-point 'url)))
    (if (and url
             (string-match "^https?://.*\\..*" url))
        (browse-url-at-point))))

(defun term-send-c-space ()
  (interactive)
  (term-send-raw-string "\0"))

(eval-after-load 'term
  '(progn
     (setq term-default-bg-color 'unspecified)
     (setq term-default-fg-color 'unspecified)

     ;;(define-key term-raw-map (kbd "C-x M-x") 'execute-extended-command)
     (define-key term-raw-map (kbd "<mouse-4>") 'term-send-up)
     (define-key term-raw-map (kbd "<mouse-5>") 'term-send-down)
     (define-key term-raw-map (kbd "C-SPC") 'term-send-c-space)
     ;; (define-key term-raw-map (kbd "ESC") 'term-send-raw-meta)
     (define-key term-raw-map (kbd "C-/") 'term-send-undo)
     (define-key term-raw-map (kbd "<mouse-1>") 'maybe-browse-url-at-point)

     (let ((i 1))
       (while (<= i 12)
         (define-key term-raw-map (vector (make-symbol (concat "f" (int-to-string i))))
           'my-term-send-fN)
         (setq i (+ i 1))))

     (defun my-term-send-fN ()
       (interactive)
       (let ((evt last-input-event))
         (when (and (symbolp evt)
                    (string-match "^f\\([0-9]+\\)" (symbol-name evt)))
           (let ((n (string-to-int (match-string 1 (symbol-name evt)))))
             (message "%s" n)
             (term-send-raw-string
              (format "\eO%c" (+ ?O n)))))))

     (defun term-send-raw-meta ()
       (interactive)
       (let ((char last-input-event))
         (when (symbolp last-input-event)
           ;; Convert `return' to C-m, etc.
           (let ((tmp (get char 'event-symbol-elements)))
             (when tmp
               (setq char (car tmp)))
             (when (symbolp char)
               (setq tmp (get char 'ascii-character))
               (when tmp
                 (setq char tmp)))))
         (setq char (logand char (lognot ?\M-\^@)))
         (term-send-raw-string (if (and (numberp char)
                                        (> char 127)
                                        (< char 256))
                                   (make-string 1 char)
                                 (format "\e%c" char)))))))

(defun term-send-undo ()
  (interactive)
  (term-send-raw-string (kbd "^_")))

(defun named-term (name directory)
  (interactive "MTerminal name: \nDIn directory: ")
  (let ((default-directory directory))
    (ansi-term (getenv "SHELL") name)))

(add-to-list 'auto-mode-alist (cons "bash-fc-[0-9]+$" 'sh-mode))

(defun dedicate-window (&optional window)
  (interactive)
  (if (null window)
      (setq window (get-buffer-window (current-buffer))))
  (set-window-dedicated-p window t))

(defun undedicate-window (&optional window)
  (interactive)
  (if (null window)
      (setq window (get-buffer-window (current-buffer))))
  (set-window-dedicated-p window nil))

(require 'dired-x)
(add-hook 'dired-mode-hook 'my-dired-mode-hook)
(defun my-dired-mode-hook ()
  (dired-omit-mode 1))
(setq dired-listing-switches "-l")

(global-set-key "\C-x\C-b" 'ibuffer-list-buffers)

(require 'ido)
(ido-mode 1)
(ido-everywhere 1)
(setq ido-auto-merge-work-directories-length -1
      ido-max-directory-size (* 256 1024)
      ido-enable-flex-matching t
      )

;(require 'helm-config)
;(global-set-key (kbd "M-x") 'helm-M-x)
;(global-set-key (kbd "C-x b") 'helm-buffers-list)

(defun my-ido-keys ()
  (mapc (lambda (K) 
          (let* ((key (car K)) (fun (cdr K)))
            (define-key ido-completion-map (edmacro-parse-keys key) fun)))
        '(("<right>" . ido-next-match)
          ("<left>"  . ido-prev-match)
          ("<up>"    . ignore             )
          ("<down>"  . ignore             )
          ("\C-n"    . ido-next-match)
          ("\C-p"    . ido-prev-match))))

(add-hook 'ido-minibuffer-setup-hook 'my-ido-keys)

; (require 'iswitchb)
; (iswitchb-mode nil)
; 
; (defadvice iswitchb-visit-buffer (before iswitchb-undedicate-window)
;   (undedicate-window))
; (ad-activate 'iswitchb-visit-buffer)
; 
; (defun iswitchb-local-keys ()
;   (mapc (lambda (K) 
;           (let* ((key (car K)) (fun (cdr K)))
;             (define-key iswitchb-mode-map (edmacro-parse-keys key) fun)))
;         '(("<right>" . iswitchb-next-match)
;           ("<left>"  . iswitchb-prev-match)
;           ("<up>"    . ignore             )
;           ("<down>"  . ignore             )
;           ("\C-n"    . iswitchb-next-match)
;           ("\C-p"    . iswitchb-prev-match))))
; 
; (add-hook 'iswitchb-minibuffer-setup-hook 'iswitchb-local-keys)

(defun my-find-file (arg)
  (interactive "P")
  (call-interactively (if arg 'my-git-find-file 'ido-find-file)))

(global-set-key (kbd "C-x C-f") 'my-find-file)

(defun my-git-wc-root ()
  (let ((root (expand-file-name
               (chomp (shell-command-to-string "git rev-parse --show-cdup")))))
    (if (string-match "/$" root)
        root
      (concat root "/"))))

(defun git-grep ()
  (interactive)
  (let ((grep-command "gr -nH -Ee ")
        (default-directory (my-git-wc-root)))
    (call-interactively 'grep)))

(defun my-git-find-file ()
  "Use ido to select a file from the git repo"
  (interactive)
  (let* ((my-project-root (my-git-wc-root))
         (git-dir (chomp (shell-command-to-string "git rev-parse --git-dir")))
         (project-files
          (split-string
           (shell-command-to-string
            (concat "git --git-dir "
                    (shell-quote-argument git-dir)
                    " ls-files -c -o"))
           "\n")))
    ;; populate hash table (display repr => path)
    (setq tbl (make-hash-table :test 'equal))
    (let (ido-list)
      (mapc (lambda (path)
              ;; format path for display in ido list
              (setq key path)
              ;; strip project root
              (setq key (replace-regexp-in-string my-project-root "" key))
              ;; remove trailing | or /
              (setq key (replace-regexp-in-string "\\(|\\|/\\)$" "" key))
              (puthash key (expand-file-name (concat my-project-root "/" path)) tbl)
              (push key ido-list))
            project-files)
      (let ((ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
            (truncate-lines nil)
            (ido-enable-flex-matching nil))
        (find-file (gethash (ido-completing-read "files: " ido-list) tbl))))))

(defconst my-github-remote-url-re
  "^\\(?:git@github.com:\\|https?://github.com/\\)\\([^/]+\\)/\\(.+?\\)\\(\\.git\\)?$"
  "Regular expression to parse a github git URL")

(defun my-github-goto-file ()
  (interactive)
  (let
      ((remote (chomp (shell-command-to-string "git config remote.origin.url")))
       (prefix (chomp (shell-command-to-string "git rev-parse --show-prefix")))
       (commit (chomp (shell-command-to-string "git rev-parse HEAD"))))
    (if (not (string-match my-github-remote-url-re remote))
        (error "Unable to parse github remote"))
    (let ((org (match-string 1 remote))
          (repo (match-string 2 remote))
          (lines
           (if (region-active-p)
               (concat
                (int-to-string (line-number-at-pos (region-beginning)))
                "-"
                (int-to-string (line-number-at-pos (region-end))))
             (int-to-string (line-number-at-pos (point))))))

      (browse-url (concat "https://github.com/"
                          org "/" repo
                          "/blob/" commit "/"
                          prefix (file-name-nondirectory (buffer-file-name))
                          "#L" lines)))))


(require 'windmove)
(windmove-default-keybindings)

;;Templates
(require 'template)
(template-initialize)
(setq template-auto-insert t)
(setq template-auto-update nil)

(add-to-list 'template-expansion-alist
             (list "AUTHOR"
                   '(insert (concat
                             user-full-name
                             " <" user-mail-address "> "))))

(defun define-bracket-keys ()
  (interactive)
  (local-set-key "{" 'insert-brackets)
  (local-set-key "}" 'insert-close))

;;Version control
(defmacro advise-to-save-windows (func)
  `(progn
     (defadvice ,func (around ,(intern (concat (symbol-name func) "-save-windows")))
       (save-window-excursion ad-do-it))
     (ad-activate ',func)))

(advise-to-save-windows vc-revert-buffer)
(setq vc-delete-logbuf-window nil)

(defun safe-require (feature)
  "Require FEATURE, failing silently if it does not exist"
  (condition-case nil
      (require feature)
    ('file-error . nil)))

(safe-require 'psvn)
; (safe-require 'vc-svk)
(safe-require 'vc-git)
(safe-require 'git)
(when (featurep 'vc-git) (add-to-list 'vc-handled-backends 'git))

(require 'magit)
(global-set-key (kbd "C-c g") 'magit-status)
(setq magit-completing-read 'magit-ido-completing-read)
; (eval-after-load 'magit
;   '(progn
;      (set-face-background 'magit-item-highlight "grey8")
;      (set-face-attribute 'magit-diff-add nil
;                          :foreground 'unspecified
;                          :inherit diff-added-face)
;      (set-face-attribute 'magit-diff-del nil
;                          :foreground 'unspecified
;                          :inherit diff-removed-face)
;      (set-face-attribute 'magit-diff-none nil
;                          :foreground 'unspecified
;                          :inherit diff-context-face)
;      ;(require 'magit-svn)
;      ))

(condition-case nil
    (progn
      (require 'vc-hg)
      (add-to-list 'vc-handled-backends 'hg))
  ('file-error . nil))

;;Perl configuration
(defalias 'perl-mode 'cperl-mode)
(add-hook 'cperl-mode-hook 'my-perl-mode-hook)
(setq cperl-invalid-face nil
      cperl-font-lock t
      cperl-indent-parens-as-block t
      cperl-indent-level 4
      cperl-continued-statement-offset 0
      cperl-brace-offset -2
      cperl-indent-region-fix-constructs nil)

(put 'cperl-indent-level 'safe-local-variable 'integerp)

(autoload 'perldoc "perl-utils" "Look up documentation on a perl module" t)
(autoload 'run-perl "inf-perl" "Run perl interactively" t)
(setq inf-perl-shell-program "/usr/bin/re.pl")

(defun my-perl-mode-hook ()
  (require 'perl-utils)
  (local-set-key "\C-cp" 'perl-check-pod)
  (local-set-key "{" 'perl-insert-brackets)
  (local-set-key "}" 'insert-close)
  (local-set-key "\C-c\C-d" (make-sparse-keymap))
  (local-set-key "\C-c\C-dh" 'cperl-perldoc)
  (local-set-key "\C-ct" 'perl-add-test)
  (local-set-key (kbd "C-M-\\") 'indent-region)
  (local-set-key "\C-c\C-v" 'cperl-build-manpage)
  (local-set-key "\C-c\C-c" 'cperl-build-manpage)
  (setq indent-tabs-mode nil))

(add-to-list 'template-expansion-alist
             (list "PERL_PACKAGE"
                   '(insert (perl-guess-package
                             (concat (car template-file)
                                     (cadr template-file))))))

(add-to-list 'auto-mode-alist (cons "\\.t$" 'perl-mode))
(add-to-list 'auto-mode-alist (cons "\\.xs$" 'c-mode))

;;Python mode

(add-to-list 'interpreter-mode-alist (cons "python2.4" 'python-mode))
(add-to-list 'interpreter-mode-alist (cons "python2.5" 'python-mode))
(add-to-list 'auto-mode-alist (cons "SConscript$" 'python-mode))
(add-to-list 'auto-mode-alist (cons "SConstruct$" 'python-mode))
(eval-after-load 'python
  '(progn
    (define-key python-mode-map (kbd "M-TAB") 'dabbrev-expand)))


(defun pydoc (word)
  "Run `pydoc' on WORD and display it in a buffer"
  (interactive "Mpydoc entry: ")
  (require 'man)
  (let ((manual-program "pydoc"))
    (Man-getpage-in-background word)))

;;JSIM mode
(autoload 'jsim-mode "jsim" nil t)
(setq auto-mode-alist (cons '("\.jsim$" . jsim-mode) auto-mode-alist))

(add-to-list 'auto-mode-alist (cons "\.uasm$" 'uasm-mode))
(defun uasm-mode ()
  (interactive)
  (make-local-variable 'asm-comment-char)
  (setq asm-comment-char ?|)
  (asm-mode))

;;PHP mode
(add-to-list 'auto-mode-alist '("\\.php[34s]?$" . php-mode))
(add-to-list 'magic-mode-alist '("<\\?php" . php-mode))
(autoload 'php-mode "php-mode" "Major mode for editing php." t)

;;Smarty template mode
(require 'smarty-mode)

;;CSS mode
(setq c-emacs-features nil)     ;;; Workaround a bug in css-mode.el
(add-to-list 'auto-mode-alist '("\\.css$" . css-mode))
(autoload 'css-mode "css-mode" "Major mode for editing CSS files" t)

;;OCaml
(add-to-list 'auto-mode-alist '("\\.ml[iylp]?$" . caml-mode))
(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)

;;Lua
(add-to-list 'auto-mode-alist '("\\.lua" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
(autoload 'lua-mode "lua-mode" "Major mode for editing Lua code." t)

(add-hook 'caml-mode-hook 'my-caml-mode-hook)
(defun my-caml-mode-hook ()
  (require 'caml-font))

;;C and c derivatives
(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0)
  (setq c-basic-offset 4
        dabbrev-case-fold-search nil)
  (cscope-minor-mode))


(require 'xcscope)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'c-mode-common-hook 'define-bracket-keys)

(define-key cscope:map (kbd "C-c .") 'cscope-find-global-definition-no-prompting)
(define-key cscope:map (kbd "C-c *") 'cscope-pop-mark)
(setq cscope-do-not-update-database t)

(defun pidof (name)
  (with-temp-buffer
    (if (zerop (shell-command (concat "pidof " name) (current-buffer)))
        (string-to-number (buffer-string))
      nil)))

(defun smells-like-c++ ()
  (when (string-match "\\.h\\'" (buffer-name))
    (save-excursion
      (goto-char (point-min))
      (if (re-search-forward "\\s \\(class\\|template\\|using\\)" nil t)
          t))))

(add-to-list 'magic-mode-alist
             '(smells-like-c++ . c++-mode))

;;;Java
(add-hook 'java-mode-hook 'define-bracket-keys)
(add-hook 'java-mode-hook 'my-java-mode-hook)

(defun my-java-mode-hook ()
  (setq *javadoc-base-url* "file:///usr/share/doc/sun-java5-doc/html/api/")
  (require 'javadoc)
  (require 'java-utils)
  (javadoc-load-classes)
  (define-key java-mode-map "\C-c\C-d" (make-sparse-keymap))
  (define-key java-mode-map "\C-c\C-dh" 'javadoc-lookup-class)
  (make-local-variable 'dabbrev-case-fold-search))

;; Scala
;;(require 'scala-mode-auto)
;;(eval-after-load 'scala-mode
;;  '(progn
;;(put 'scala-mode-indent:step 'safe-local-variable 'integerp)))

;;; ANTLR
(autoload 'antlr-mode "antlr-mode" nil t)
(setq auto-mode-alist (cons '("\\.g\\'" . antlr-mode) auto-mode-alist))

;; Javascript
(autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.json$" . js-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-mode))
; (add-hook 'js2-mode-hook 'moz-minor-mode)
(add-hook 'js2-mode-hook 'js2-enter-mirror-mode)
(add-hook 'js2-mode-hook 'my-js2-mode-hook)
; (add-hook 'js2-mode-hook 'define-bracket-keys)
(setq js2-use-font-lock-faces t
      js2-allow-keywords-as-property-names t
      js2-mode-show-strict-warnings nil
      js2-bounce-indent-p t)
(setq-default js2-basic-offset 2)

(defadvice js2-enter-key (after js2-enter-key-indent)
  (let ((js2-bounce-indent-flag nil))
    (js2-indent-line)))
; (ad-activate 'js2-enter-key)

(eval-after-load 'js2-mode
  '(progn
     (set-face-attribute 'js2-warning-face nil :underline "cyan")
     (set-face-attribute 'js2-error-face nil   :underline "OrangeRed")))

(defun my-js2-mode-hook ()
  (local-set-key (kbd "C-a") 'beginning-of-line-dwim)
  (local-set-key (kbd "C-x `") 'next-error)
  (local-set-key (kbd "M-TAB") 'dabbrev-completion)
  (setq forward-sexp-function nil))

(put 'js2-basic-offset 'safe-local-variable 'integerp)

(defun my-javascript-mode-hook ()
  (require 'moz))

(require 'coffee-mode)
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))

;;;LaTeX
(add-hook 'latex-mode-hook 'my-latex-mode-hook)
(add-hook 'LaTeX-mode-hook 'my-latex-mode-hook)
(add-hook 'TeX-mode-hook 'my-latex-mode-hook)
(add-hook 'tex-mode-hook 'my-latex-mode-hook)

(defun my-latex-mode-hook ()
  (require 'reftex)
  (local-set-key "{" '(lambda ()
                        (interactive)
                        (let ((parens-require-spaces nil))
                          (insert-pair))))
  (local-set-key "}" 'insert-close)
  (reftex-mode 1)
  (flyspell-mode 1))

(eval-after-load 'tex
  '(progn
     (setq TeX-command-list
           (cons '("Gv" "gv %s.ps" TeX-run-background t t :help "Run gv on postscript")
                 TeX-command-list))
     (setq TeX-command-list
           (cons '("Evince" "evince %s.ps" TeX-run-background t t :help "Run evince on postscript")
                 TeX-command-list))
     (setq TeX-command-list
           (cons '("xpdf" "xpdf %s.pdf" TeX-run-background t t :help "Run xpdf on PDF")
                 TeX-command-list))
     (setq TeX-command-list
           (cons '("PDF" "dvipdf %s.dvi" TeX-run-background t t :help "Generate a PDF")
                 TeX-command-list))
     (setq TeX-command-list
           (cons '("PDFLatex" "pdflatex %s.tex" TeX-run-background t t :help "Run pdflatex")
                 TeX-command-list))
     (let ((pdfview (assoc-string "^pdf$" TeX-output-view-style)))
       (setcdr (cdr pdfview) (list "evince %o")))
     (setq TeX-print-command "pdf2ps %s.pdf - | lpr -P%p -h")
     (TeX-global-PDF-mode)))

(defun TeX-count-words ()
  (interactive)
  (save-excursion
    (shell-command-on-region (point-min) (point-max) "detex | wc -w")))

(eval-after-load 'info
  '(progn
     (setq Info-directory-list
           (cons "~/.elisp/auctex/doc" Info-default-directory-list))
     (define-key Info-mode-map "B" 'Info-history-back)
     (define-key Info-mode-map "F" 'Info-history-forward)))

;;;Lisps
;;;Scheme

(defun pretty-lambdas ()
  (font-lock-add-keywords
   nil `(("\\<lambda\\>"
          (0 (progn (compose-region (match-beginning 0) (match-end 0)
                                    ,(make-char 'greek-iso8859-7 107))
                    nil))))))

(require 'quack)

(setq quack-programs '()
      quack-fontify-style 'emacs)

(defmacro define-scheme-implementation (name &optional args)
  `(setq quack-programs (cons ,(if args (concat name " " args) name) quack-programs)))
;  `(defun ,(intern (concat "scheme-use-" name)) ()
;    (interactive)
;    (setq scheme-program-name ,(concat name " " (or args "")))))

(define-scheme-implementation "mzscheme")
(define-scheme-implementation "mechanics")
(define-scheme-implementation "guile" "--debug -- -emacs")
(define-scheme-implementation "mit-scheme")
(define-scheme-implementation "kawa")
(define-scheme-implementation "csi")
(define-scheme-implementation "scheme48")
(define-scheme-implementation "racket")

(add-to-list 'auto-mode-alist
             (cons (concat "/\\."
                           (regexp-opt '("guile"
                                         "mzscheme"
                                         "kawarc.scm"
                                         "scheme.init"
                                         "edwin") t)
                           "$") 'scheme-mode))

(add-to-list 'auto-mode-alist
             (cons "\\.arc$" 'scheme-mode))

(autoload 'run-scheme "cmuscheme" "Run an inferior scheme process." t)

(setq save-abbrevs nil)

(defun my-scheme-mode-hook ()
  (pretty-lambdas))

(add-hook 'scheme-mode-hook 'define-lisp-keys t)
(add-hook 'inferior-scheme-mode-hook 'define-lisp-keys t)
(add-hook 'scheme-mode-hook 'my-scheme-mode-hook)
(add-hook 'inferior-scheme-mode-hook 'my-scheme-mode-hook)

(setq comint-scroll-to-bottom-on-ouput t)

(add-to-list 'auto-mode-alist
             (cons (concat "/\\."
                           (regexp-opt '("sbclrc"
                                         "cmucl-init"
                                         "clrc") t)
                           "$") 'lisp-mode))

(add-hook 'lisp-mode-hook 'my-lisp-mode-hook)
(add-hook 'lisp-mode-hook 'my-lisp-mode-common-hook)
(add-hook 'lisp-mode-hook 'pretty-lambdas)

(defun my-lisp-mode-hook ()
  )

(setq common-lisp-hyperspec-root "file:///usr/share/doc/hyperspec/")

(add-to-list 'auto-mode-alist (cons "\\.asd\\'" 'lisp-mode))

(add-hook 'clojure-mode-hook 'define-lisp-keys)

;;;elisp
(add-hook 'emacs-lisp-mode-hook 'define-elisp-keys)
(add-hook 'emacs-lisp-mode-hook 'my-lisp-mode-common-hook)
(add-hook 'emacs-lisp-mode-hook 'pretty-lambdas)
(add-hook 'lisp-interaction-mode-hook 'define-elisp-keys)
(add-hook 'lisp-interaction-mode-hook 'my-lisp-mode-common-hook)
(add-hook 'lisp-interaction-mode-hook 'pretty-lambdas)

;;Lisp keybindings

(defun define-lisp-keys ()
;;   (local-set-key "[" 'insert-parentheses)
;;   (local-set-key "]" (lambda () (interactive) (insert-close "")))
;;   (local-set-key "(" (lambda () (interactive) (insert "[")))
;;  (local-set-key ")" (lambda () (interactive) (insert "]")))

  (local-set-key "(" 'insert-parentheses)
  (local-set-key ")" 'insert-close)

  (local-set-key (kbd "M-t") 'transpose-sexps)
  (local-set-key (kbd "M-b") 'backward-sexp)
  (local-set-key (kbd "M-f") 'forward-sexp)
  (local-set-key (kbd "M-a") 'beginning-of-defun)
  (local-set-key (kbd "M-e") 'end-of-defun)
  (local-set-key (kbd "M-_") 'unwrap-next-sexp)
  (local-set-key (kbd "M-q") 'indent-sexp)
  (local-set-key (kbd "M-(") 'blink-matching-open)
  (local-set-key (kbd "M-u") 'backward-up-list)
  (local-set-key (kbd "M-d") 'down-list)
  (local-set-key (kbd "M-k") 'kill-sexp)
  (local-set-key (kbd "M-DEL") 'backward-kill-sexp)
  (local-set-key (kbd "DEL") 'backspace-unwrap-sexp)

  (local-set-key (kbd "C-M-q") 'fill-paragraph)
  (local-set-key (kbd "TAB") 'indent-and-complete-symbol-generic))

(defun define-elisp-keys ()
  (define-lisp-keys))

(defun my-lisp-mode-common-hook ()
  (setq indent-tabs-mode nil))

;; proto
(require 'proto-mode)
(add-hook 'proto-mode-hook 'define-lisp-keys)
(setq auto-mode-alist
      (delete-if (lambda (k) (and (consp k) (eq (cdr k) 'proto-mode))) auto-mode-alist))

;;;Haskell

(require 'haskell-mode)
(require 'inf-haskell)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-to-list 'auto-mode-alist (cons "\\.l?hsc?$" 'haskell-mode))

(setq haskell-program-name "ghci")

;; ruby
; (autoload 'ruby-mode "ruby-mode" "" t)
(add-to-list 'auto-mode-alist (cons "\\.rb$" 'ruby-mode))
; gdash graphs are .graph
(add-to-list 'auto-mode-alist (cons "\\.graph$" 'ruby-mode))
(add-to-list 'auto-mode-alist (cons "\\(Rake\\|Gem\\|Guard\\|Vagrant\\)file$" 'ruby-mode))
(add-to-list 'auto-mode-alist (cons "\\.gemspec$" 'ruby-mode))
(add-to-list 'interpreter-mode-alist (cons "ruby" 'ruby-mode))

; (autoload 'run-ruby "inf-ruby" "Run an inferior ruby process" t)
; (autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
; (add-hook 'ruby-mode-hook 'inf-ruby-keys)
(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)
(defun my-ruby-mode-hook ()
  (local-set-key (kbd "TAB") 'indent-and-complete-symbol-generic)
  (make-local-variable 'ac-ignores)
  (add-to-list 'ac-ignores "end")
  (add-to-list 'ac-ignores "en")
  (add-to-list 'ac-ignores "else")
  (add-to-list 'ac-ignores "do")
  (setq ruby-deep-indent-paren nil))

;; mmm-mode and ERB
;(require 'mmm-auto)
;(require 'mmm-erb)
;(setq mmm-global-mode 'maybe)

;(mmm-add-mode-ext-class 'html-erb-mode "\\.erb\\'" 'erb)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . html-erb-mode))
;(set-face-background 'mmm-default-submode-face "#222")

;; Matlab

(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)
(fset 'run-matlab 'matlab-shell)

(setq matlab-shell-command "octave")
(setq matlab-shell-command-switches '())

;; LLVM development

(let ((llvm-el (expand-file-name "~/code/llvm/utils/emacs")))
  (when (file-exists-p llvm-el)
    (load-file (concat llvm-el "/emacs.el"))
    (add-to-list 'load-path llvm-el)
    (require 'llvm-mode)
    (require 'tablegen-mode)))

;; Apache mode
(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" . apache-mode))


;; google calendar client

(load-library "g")
(setq g-user-email "nelhage@gmail.com")
(setq g-html-handler 'browse-url-of-buffer)

;; Mediawiki
(require 'mediawiki)
(setq mediawiki-site-alist '())

;;Evil DOS file endings, eeeeeeeeevil
(add-hook 'find-file-hook 'find-file-check-line-endings)

;; automatically set mode after I type a shebang
(defun magic-mode-newline-and-indent ()
  (interactive "*")
  (let ((shebang (and (eq major-mode 'fundamental-mode)
                      (save-excursion
                        (beginning-of-line)
                        (looking-at "#!")))))
    (newline-and-indent)
    (when shebang
      (normal-mode))))

;; smerge-mode
(eval-after-load "smerge-mode"
  '(progn
     (set-face-background 'smerge-refined-change "#003333")
     (setq smerge-base-re "^|||||||.*\n")))

(defun sm-try-smerge ()
  (save-excursion
    (goto-char (point-min))
    (when (re-search-forward "^<<<<<<< " nil t)
      (smerge-mode 1))))
(add-hook 'find-file-hook 'sm-try-smerge t)

(defun dos-file-endings-p ()
  (string-match "dos" (symbol-name buffer-file-coding-system)))

(defun find-file-check-line-endings ()
  (when (dos-file-endings-p)
    ;(set-buffer-file-coding-system 'undecided-unix)
    ;(set-buffer-modified-p nil)
    ))

;;nxml-mode
(load "~/.elisp/nxml/rng-auto.el")
(fset 'xml-mode 'nxml-mode)
(add-to-list 'auto-mode-alist
             (cons (concat "\\."
                           (regexp-opt '("xml" "xsd" "sch"
                                         "rng" "xslt" "svg"
                                         "rss" "plist" "html"
                                         "xhtml") t) "\\'")
                   'nxml-mode))

(add-to-list 'magic-mode-alist
             (cons "<\\?xml" 'nxml-mode))

(add-hook 'nxml-mode-hook 'my-nxml-mode-hook)

(defun my-nxml-mode-hook ()
  (local-set-key (kbd "C-c C-e") 'nxml-finish-element)
  (local-set-key (kbd "C-M-f") 'nxml-forward-element)
  (local-set-key (kbd "C-M-b") 'nxml-backward-element)
  (local-set-key (kbd "C-M-u") 'nxml-up-element)
  (local-set-key (kbd "C-M-d") 'nxml-down-element)
  (local-set-key (kbd "M-k") 'nxml-kill-element)
  (local-set-key (kbd "C-c ]") 'nxml-finish-element)
  (setq next-error-function 'nxml-next-error))

(defun nxml-next-error (arg reset)
  (if reset (rng-first-error))
  (rng-next-error arg))

(defadvice nxml-up-element (after nxml-up-element-goto-start)
  "Make nxml-up-element go to the start, not end, of the
surrounding xml expression"
  (nxml-backward-element))

(ad-activate 'nxml-up-element)

(defun nxml-kill-element ()
  (interactive)
  (let ((start (point)))
    (nxml-forward-element)
    (kill-region start (point))))

;;;psgml-mode
; (autoload 'sgml-mode "psgml" "Major mode to edit SGML files." t)
; (autoload 'xml-mode "psgml" "Major mode to edit XML files." t)

(setq sgml-set-face t
      sgml-indent-data t
      sgml-auto-activate-dtd t)

;;; Zen Coding
(autoload 'zencoding-mode "zencoding-mode" "Minor mode to enable Zen coding")
; (add-hook 'sgml-mode-hook 'zencoding-mode)
; (add-hook 'nxml-mode-hook 'zencoding-mode)

;;;Mason-mode
(defun mason-mode ()
  (interactive)
  (html-mode)
  (mmm-ify-by-class 'mason))

;;Jifty mason components
(add-to-list 'auto-mode-alist '("web/templates/[^.]*$" . mason-mode))
(add-to-list 'magic-mode-alist `(,(concat
                                   "<%" (regexp-opt '("args" "init") t) ">")
                                 . mason-mode))
(add-to-list 'magic-mode-alist '("\\`<&" . mason-mode))
;(mmm-add-mode-ext-class 'sgml-mode "web/templates/[^.]*$" 'mason)

;; html
(add-hook 'html-mode-hook 'my-html-mode-hook)

(defun my-html-mode-hook ()
  (local-set-key (kbd "C-c C-e") 'sgml-close-tag))

;; dot-mode
(add-to-list 'auto-mode-alist '("\\.dot\\'" . graphviz-dot-mode))
(autoload 'graphviz-dot-mode "graphviz-dot-mode" "Major mode for editing Graphviz dot files" t)

(eval-after-load 'graphviz-dot-mode
  '(progn
     (define-key graphviz-dot-mode-map (kbd ";") 'self-insert-command)
     (define-key graphviz-dot-mode-map (kbd "C-c C-c") 'graphviz-dot-preview)))

;;; ESS

; (require 'ess-site)
; (ess-restore-asm-extns)

(setq-default backup-inhibited t)

;; puppet

(autoload 'puppet-mode "puppet-mode" "Major mode for editing puppet manifests")

(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; markdown
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.md$" . markdown-mode) auto-mode-alist))

;; golang

(defun golang-roots ()
  (let ((goroot (getenv "GOROOT"))
        (gopath (getenv "GOPATH"))
        (roots '()))
    (when goroot
      (setq roots (cons goroot roots)))
    (when gopath
      (setq roots (append (split-string gopath ":") roots)))
    roots))

(defun golang-require (path feature)
  (let ((dir (member-if (lambda (dir) (file-directory-p (concat dir "/" path))) (golang-roots))))
    (when dir
      (add-to-list 'load-path (expand-file-name (concat (car dir) "/" path)))
      (require feature))))

(defun golang-load (path)
  (let ((dir (member-if (lambda (dir) (file-exists-p (concat dir "/" path))) (golang-roots))))
    (when dir
      (load (concat (car dir) "/" path)))))

(golang-require "misc/emacs" 'go-mode-load)
(golang-require "src/github.com/nsf/gocode/emacs/" 'go-autocomplete)
(golang-require "src/github.com/golang/lint/misc/emacs" 'golint)
(golang-load "src/golang.org/x/tools/refactor/rename/rename.el")
(let ((oracle-dir (concat (getenv "GOPATH") "/src/code.google.com/p/go.tools/cmd/oracle")))
  (when (file-directory-p oracle-dir)
    (load-file (concat oracle-dir "/oracle.el"))
    (add-hook 'go-mode-hook 'go-oracle-mode)
    (setq go-oracle-command "oracle")))

(add-hook 'go-mode-hook 'go-eldoc-setup)
(add-hook 'go-mode-hook 'my-go-mode-hook)
(defun my-go-mode-hook ()
  (set (make-local-variable 'company-backends) '(company-go))
  (set (make-local-variable 'company-minimum-prefix-length) 0)
  (local-set-key (kbd "M-.") 'godef-jump))
(when (fboundp 'gofmt-before-save)
  (add-hook 'before-save-hook 'gofmt-before-save)
  (add-to-list 'safe-local-variable-values '(gofmt-command . "goimports"))
  (add-to-list 'safe-local-variable-values '(gofmt-command . "gofmt"))
  (let ((goimports (string-trim (shell-command-to-string "which goimports"))))
    (when (not (string-equal "" goimports))
      (setq gofmt-command goimports))))

;; protobufs
(require 'protobuf-mode)
(add-to-list 'auto-mode-alist (cons "\\.proto$" 'protobuf-mode))

;;; ADD NEW LANGUAGE MODES HERE

;;Mailcrypt
(require 'mailcrypt)
(mc-setversion "gpg")

(setq ediff-split-window-function 'split-window-horizontally)

;; Org mode

(setq org-directory "~/nelhage/org")
(require 'org-mobile)
(setq org-hide-leading-stars t
      org-log-done 'time
      org-agenda-files (list (concat org-directory "/todo.org")
                             (concat org-directory "/stripe.org"))
      org-agenda-window-setup 'current-window
      org-agenda-restore-windows-after-quit t
      org-default-notes-file (concat org-directory "/notes.org")
      org-remember-templates
      '(("Todo" ?t "* TODO %?\n" "todo.org" "Tasks")
        ("Stripe" ?s "* TODO %?\n" "stripe.org" "Stripe")
        ("Buy" ?b "* TODO %?" "todo.org" "To Buy"))
      org-agenda-custom-commands
      '(("W" "Work agenda" agenda ""
         ((org-agenda-files
           (list (concat org-directory "/stripe.org")))))
        ("O" "Other agenda" agenda ""
         ((org-agenda-files
           (list (concat org-directory "/todo.org"))))))
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t
      org-agenda-todo-keyword-format "%-6s"
      org-agenda-todo-ignore-deadlines t
      org-todo-keywords
      '((sequence "TODO" "INPROGRESS" "PENDING-REVIEW" "NEEDS-TESTING" "|" "DONE")
        (sequence "|" "CANCELLED"  "DELEGATED"))
      org-deadline-warning-days 0
      org-return-follows-link t
      org-mobile-inbox-for-pull (concat org-directory "/mobile.org")
      org-mobile-directory "~/Dropbox/org/mobile"
      line-move-visual nil)

(eval-after-load 'org-agenda
  '(progn
     (set-face-attribute 'org-todo nil
                         :inverse-video nil)))

(defun org-agenda-skip-future-scheduled ()
  (let ((end (save-excursion (progn (outline-next-heading) (1- (point))))))
    (when (re-search-forward org-scheduled-time-regexp end t)
      (let ((ss (match-string 1))
            (sd (org-time-string-to-absolute (match-string 1))))
        (if (> sd (calendar-absolute-from-gregorian date))
            end)))))

; (setq org-agenda-skip-function 'org-agenda-skip-future-scheduled)

; (org-remember-insinuate)
(global-set-key (kbd "C-c r") 'org-remember)
(global-set-key (kbd "C-c a") 'org-agenda)

(eval-after-load 'org
  '(progn
     (define-key org-mode-map (kbd "C-c t") 'org-todo)
     (define-key org-mode-map (kbd "M-TAB") 'org-cycle)
     (define-key org-mode-map (kbd "M-p") 'outline-backward-same-level)
     (define-key org-mode-map (kbd "M-n") 'outline-forward-same-level)
     ;(define-key org-mode-map (kbd "RET") 'org-meta-return)
     (set-face-foreground 'org-todo "#FF6666")
     (set-face-foreground 'org-done "#00FF00")))

;; SES mode
(add-hook 'ses-mode-hook 'my-ses-mode-hook)
(defun my-ses-mode-hook ()
  (whitespace-mode -1))

;;Livejournal
(autoload 'lj-login "ljupdate" "Log in to Livejournal" t)

;;Disabled commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)

;;Setup my working emacs session

(add-hook 'emacs-startup-hook 'my-startup-hook)

(defun my-startup-hook ()
  (set-frame-font default-font t)
  (server-start)
  (require 'edit-server)
  (edit-server-start)
  (find-file-noselect "~/.elisp/dot-emacs")
  (save-window-excursion (shell))
  (setup-terminals))

;;; Misc stuff

(require 'kerberos)

(setq asm-comment-char ?\;)

(add-hook 'asm-mode-hook 'my-asm-mode-hook)

(defun my-asm-mode-hook ()
  (define-key asm-mode-map (kbd "#") 'self-insert-command))

(add-to-list 'auto-mode-alist (cons "/Makefrag$" 'makefile-mode))
(add-to-list 'auto-mode-alist (cons "/Makefile[^/]+$" 'makefile-mode))

;(setq browse-url-browser-function 'w3m-other-window-new-session)
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program
      (cond
       ((eq system-type 'darwin) "open")
       (t "xdg-open"))
      w3m-home-page  "http://google.com")

(put 'asm-comment-char 'safe-local-variable 'characterp)
(put 'c-indentation-style 'safe-local-variable 'symbolp)

(defvar initial-terminals '() "Terminals to create initially")
(setq initial-terminals
      '((term "nelhage.com" "~/")
        ;; (shell "linux-2.6" "~/code/linux")
        ;; (shell "barnowl-dev" "~/code/barnowl")
        ;; (shell "llvm-dev" "~/code/llvm")
        ;; (shell "mysql" "~/")
        (shell "livegrep-dev" "~/code/livegrep")
        (term "mutt-nelhage" "~/")
        (term "mutt-stripe" "~/")
        (term "stripe-dev" "~/stripe")))

(defun setup-terminals ()
  (interactive)
  (dolist (spec initial-terminals)
    (destructuring-bind (type name dir) spec
      (when (and (not (get-buffer (concat "*" name "*")))
                 (file-exists-p dir))
        (case type
          (term
           (named-term name dir))
          (shell
           (named-shell name dir)))))))

