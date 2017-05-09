 ;; disable auto-save and auto-backup
(setq auto-save-default nil)
(setq make-backup-files nil)

(require 'linum)
(require 'package)

(global-linum-mode 1)
(global-visual-line-mode 1)

(global-set-key (kbd "M-3") 'split-window-horizontally) ; was digit-argument
(global-set-key (kbd "M-2") 'split-window-vertically) ; was digit-argument
(global-set-key (kbd "M-1") 'delete-other-windows) ; was digit-argument
(global-set-key (kbd "M-0") 'delete-window) ; was digit-argument
(global-set-key (kbd "M-o") 'other-window) ; was facemenu-keymap

;; To help Unlearn C-x 0, 1, 2, o
(global-unset-key (kbd "C-x 3")) ; was split-window-horizontally
(global-unset-key (kbd "C-x 2")) ; was split-window-vertically
(global-unset-key (kbd "C-x 1")) ; was delete-other-windows
(global-unset-key (kbd "C-x 0")) ; was delete-window
(global-unset-key (kbd "C-x o")) ; was other-window
(icomplete-mode 99)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                     ("marmalade" . "http://marmalade-repo.org/packages/")
                     ("melpa" . "https://melpa.org/packages/")))

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

(package-initialize) ;; You might already have this line

; Mode Loads
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.fshader$" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vshader$" . glsl-mode))

(defun normal-python-compile ()
  "Use compile to run python programs"
  (interactive)
  (save-buffer)
  (message (pwd))
  (compile (concat "python " (buffer-name))))


(defun django-compile()
  "running Django style compile for tests"
  (message "compiling for django")
  (save-buffer)
  (setq app (nth 1 (nreverse (split-string default-directory "/"))))
  (compile (concat "../manage.py test " app "." (python-current-defun)))
  )

(defun python-compile ()
  "Run tests if in Django"
  (interactive)
  (if (string= (file-name-extension (buffer-file-name (current-buffer))) "py")
      (if (file-exists-p "../manage.py")
	  (django-compile)
	(normal-python-compile)
	)
    (message "Error: not python")
    )
  )

(defun rails-compile ()
  "run tests if in rails"
  (interactive)
  (message "compiling for rails")
  (re-search-backward "\\bit" nil t)
  (let (
	(line-number (number-to-string (line-number-at-pos)))
	(spec (buffer-file-name))
	)

    (compile (concat "../../script/spec " spec " -l " line-number))
    )
  )

(defun normal-ruby-compile ()
  "Use compile to run ruby programs"
  (interactive)
  (save-buffer)
  (compile (concat "ruby " (buffer-name))))

(defun ruby-compile ()
  "Run tests if in Rails"
  (interactive)
  (if (string= (file-name-extension (buffer-file-name (current-buffer))) "rb")
      (if (file-exists-p "../../config/environment.rb")
	  (rails-compile)
	(normal-ruby-compile)
	)
    (message "Error: not ruby")
    )
  )


(defun shell-compile ()
  "Use compile to run shell programs"
  (interactive)
  (save-buffer)
  (compile (concat "/bin/bash " (buffer-name))))

(defun clisp-compile ()
  "Use compile to run common lisp programs"
  (interactive)
  (save-buffer)
  (compile (concat "clisp " (buffer-name))))


(defun perl-compile ()
  "Use compile to run perl programs"
  (interactive)
  (save-buffer)
  (message (pwd))
  (compile (concat "perl " (buffer-name))))

(setq compilation-scroll-output t)



;; compilation mode
(add-hook 'python-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'python-compile)))

(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'ruby-compile)))

(add-hook 'sh-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'shell-compile)))

(add-hook 'lisp-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'clisp-compile)))

(add-hook 'perl-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-c") 'perl-compile)))


(global-set-key (kbd "C-c C-n") 'neotree-toggle)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (ffip-project-root))
	(file-name (buffer-file-name)))
    (if project-dir
	(progn
	  (neotree-dir project-dir)
	  (neotree-find file-name))
      (message "Could not find git project root."))))

(global-set-key (kbd "C-c C-p") 'neotree-project-dir)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (base16-eighties-dark)))
 '(custom-safe-themes
   (quote
    ("e033c4abd259afac2475abd9545f2099a567eb0e5ec4d1ed13567a77c1919f8f" "3f873e7cb090efbdceafb8f54afed391899172dd917bb7a354737a8bb048bd71" "3fb38c0c32f0b8ea93170be4d33631c607c60c709a546cb6199659e6308aedf7" "cdfb22711f64d0e665f40b2607879fcf2607764b2b70d672ddaa26d2da13049f" "f245c9f24b609b00441a6a336bcc556fe38a6b24bfc0ca4aedd4fe23d858ba31" "6916fa929b497ab630e23f2a4785b3b72ce9877640ae52088c65c00f8897d67f" "935ec804d63012383124524dcc365f9e25baa87e4c970cd1eaaca0f771b56ce7" default))))
(put 'set-goal-column 'disabled nil)

(setq-default indent-tabs-mode nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(add-to-list 'load-path "~/.emacs.d/pkg/coffee-mode/")

(require 'coffee-mode)

(setq exec-path (cons "/usr/local/go/bin" exec-path))

(defun my-go-mode-hook ()
                                        ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
                                        ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
                                        ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
                                        ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook 'my-go-mode-hook)

(setq js-indent-level 2)
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

(require 'whitespace)
(setq whitespace-style '(face empty lines-tail trailing))
(global-whitespace-mode t)
(add-to-list 'load-path "~/.emacs.d/pkg/flymake-easy/")
(add-to-list 'load-path "~/.emacs.d/pkg/flymake-python-pyflakes/")
(add-to-list 'load-path "~/.emacs.d/pkg/typescript-mode/")

(require 'flymake-easy)
(require 'flymake-python-pyflakes)
(require 'typescript-mode)
(require 'multiple-cursors)

;; (add-hook 'python-mode-hook 'flymake-python-pyflakes-load)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;;(load-file "~/.emacs.d/themes/base16-eighties-dark-theme.el")
;;(load-file "~/.emacs.d/themes/emacs-leuven-theme/leuven-theme.el")
;;(load-file "~/.emacs.d/themes/base16-solarized-dark-theme.el")
(load-theme 'zenburn t)


(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(add-to-list 'load-path "/Users/david.shure/go/src/github.com/golang/lint/misc/emacs")
(require 'golint)

;; (require 'flymake-jslint)
;; (add-hook 'js-mode-hook 'flymake-jslint-load)
;; (setq flymake-jslint-args ())

;; (global-git-gutter-mode +1)
(global-auto-revert-mode t)

(exec-path-from-shell-initialize)
