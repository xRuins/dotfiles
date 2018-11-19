;; initialize el-get
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(setq-default indent-tabs-mode nil)
(setq el-get-verbose t)
(add-hook 'js-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))
(add-to-list 'load-path (locate-user-emacs-file "el-get/el-get"))
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

;; el-get packages
(setq elget-packages
      (append
       ;; list of packages we use straight from official recipes
       '(
         auto-complete
         coffee-mode
         color-theme
         color-theme-solarized
         dash
         dockerfile-mode
         expand-region
         flycheck
         flycheck-pos-tip
         flymake-easy
         fringe-helper
         git-gutter-fringe
         go-autocomplete
         go-def
         go-eldoc
         go-imports
         go-mode
         go-test
         haml-mode
         helm
         helm-ag
         helm-c-flycheck
         helm-ghq
         helm-ls-git
         helm-robe
         json-mode
         magit
         markdown-mode
         markdown-toc
         nginx-mode
         popwin
         powerline
         protobuf-mode
         rainbow-delimiters
         robe-mode
         rspec-mode
         rubocop
         ruby-block
         ruby-electric
         ruby-refactor
         slim-mode
         smart-compile
         visual-regexp
         yaml-mode
         yascroll
         yasnippet
         )
       )
      )

(el-get 'sync elget-packages)
;; initialize emacs-bundled package manager
(package-initialize)

;; color-theme
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)

;; encoding
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; emacs UI behaviours
(setq inhibit-startup-message t)
(setq suggest-key-bindings t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq x-select-enable-clipboard t)
(setq vc-follow-symlinks t)
(setq auto-revert-check-vc-info t)
(menu-bar-mode 0)

;; syntax
(setq default-tab-width 4)
(c-set-offset 'arglist-close 0) ;; fix indentation when parenthesises across plural line

;; yascroll
(global-yascroll-bar-mode 1)

;; keybind
(global-set-key (kbd "C-@") 'er/expand-region)
(global-set-key (kbd "C-c m") 'magit-status)
(global-set-key (kbd "C-h") 'left-char)
(global-set-key (kbd "C-j") 'next-line)
(global-set-key (kbd "C-k") 'previous-line)
(global-set-key (kbd "C-l") 'right-char)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
(global-set-key (kbd "C-z") 'other-window)
(global-set-key (kbd "M-n") "\C-u1\C-v")
(global-set-key (kbd "M-p") "\C-u1\M-v")
(global-set-key (kbd "M-x") 'helm-M-x)

;; powerline
(setq powerline-color1 "#073642")
(setq powerline-color2 "#002b36")
(set-face-attribute 'mode-line nil
                    :foreground "#fdf6e3"
                    :background "#2aa198"
                    :box nil)
(set-face-attribute 'mode-line-inactive nil
                    :box nil)
(powerline-default-theme)

;; helm-file
(defadvice helm-for-files
    (around helm-for-files-no-highlight activate)
  "No highlight when using helm-for-files."
  (let ((helm-mp-highlight-delay nil))
    ad-do-it))

(defconst helm-for-files-preferred-list
  '(helm-source-buffers-list
    helm-source-recentf
    helm-source-file-cache
    helm-source-ghq
    helm-source-files-in-current-dir
    ))

;; better helm-find-files
(defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-exist activate)
  "Execute command only if CANDIDATE exists"
  (when (file-exists-p candidate)
    ad-do-it))
(setq helm-ff-newfile-prompt-p nil)
(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)

;; helm-ag
(if (executable-find "ag")
    (progn
      (global-set-key (kbd "C-s") 'helm-do-ag-this-file-with-fallback)
      (global-set-key (kbd "C-q") 'helm-do-ag-project-root)
      )
  )

(defun helm-do-ag-this-file-with-fallback ()
  (interactive)
  (helm-aif (buffer-file-name)
      (helm-do-ag default-directory (list it))
    (isearch-forward)
    )
  )

;; smart-compile
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;; recentf
(setq recentf-max-saved-items 2000) ;; 2000ファイルまで履歴保存する
(setq recentf-auto-cleanup 'never)  ;; 存在しないファイルは消さない
(setq recentf-exclude '("/recentf" "COMMIT_EDITMSG" "/.?TAGS" "^/sudo:" "/\\.emacs\\.d/games/*-scores" "/\\.emacs\\.d/\\.cask/"))
(setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(recentf-mode 1)

;; linum
(setq linum-format "%3d ")
(global-linum-mode t)

;; show-paren-mode
(show-paren-mode 1)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)

;; git-gutter
;; (git-gutter:linum-setup)
;; (global-git-gutter-mode t)
;; (global-set-key (kbd "C-x C-g") 'git-gutter)
;; (global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
;; (global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
;; (global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
;; (global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
;; (global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)
;; (global-set-key (kbd "C-x v SPC") 'git-gutter:mark-hunk)

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'ruby-mode-hook (lambda ()
                            (setq show-trailing-whitespace nil)))

;; don't make backup files
(setq make-backup-files nil)
(setq auto-save-default nil)

;; markdown
(unless (package-installed-p 'markdown-mode)
  (package-refresh-contents) (package-install 'markdown-mode))
(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.md$" . markdown-mode) auto-mode-alist))

;; fundamental settings for Ruby
(autoload 'ruby-mode "ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.schema\\'" . ruby-mode)) ;; ridgepole schema files
(setq ruby-deep-indent-paren-style nil)
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(add-hook 'ruby-mode-hook
	  (ruby-electric-mode)
	  (robe-mode)
	  (setq ruby-indent-level 2)
	  )
(define-key ruby-mode-map [return] 'reindent-then-newline-and-indent)
(define-key ruby-mode-map (kbd "C-c C-d") 'xmp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (robe yaml-mode slim-mode markdown-mode helm-flycheck haml-mode)))
 '(ruby-insert-encoding-magic-comment nil))

;; rspec
(autoload 'rspec-mode "rspec-mode")
(add-hook 'ruby-mode-hook 'rspec-mode)

;; auto-complete
(global-auto-complete-mode t)

;; flycheck
(autoload 'flycheck-mode "flycheck")
(add-hook 'after-init-hook #'global-flycheck-mode)
(setq flycheck-check-syntax-automatically '(idle-change mode-enabled new-line save))
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

;; smart-compile
(define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
(define-key ruby-mode-map (kbd "C-c C-c") (kbd "C-c c C-m"))

;; highlight block
(setq ruby-block-highlight-toggle t)

;; slim
(unless (package-installed-p 'slim-mode)
  (package-refresh-contents) (package-install 'slim-mode))
(add-to-list 'auto-mode-alist '("\\.slim?\\'" . slim-mode))

;; haml
(unless (package-installed-p 'haml-mode)
  (package-refresh-contents) (package-install 'haml-mode))
(add-to-list 'auto-mode-alist '("\\.ha?ml?\\'" . haml-mode))

;; protobuf
(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

;; json
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

;; go
(add-hook 'before-save-hook 'gofmt-before-save)
(add-hook 'go-mode-hook (lambda ()
                          (local-set-key (kbd "M-.") 'godef-jump)))

;; yaml
(unless (package-installed-p 'yaml-mode)
  (package-refresh-contents) (package-install 'yaml-mode))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.ya?ml$" . yaml-mode))
(define-key yaml-mode-map (kbd "C-m") 'newline-and-indent)

;; Markdown
(defun cleanup-org-tables ()
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "-+-" nil t) (replace-match "-|-"))))
(add-hook 'markdown-mode-hook 'orgtbl-mode)
(add-hook 'markdown-mode-hook
          #'(lambda()
              (add-hook 'after-save-hook 'cleanup-org-tables  nil 'make-it-local)))
