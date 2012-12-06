(require 'linum)
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


(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rhtml$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.html.erb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.erb$" . ruby-mode))

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (deeper-blue))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
