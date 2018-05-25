;; initialize el-get
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(setq-default indent-tabs-mode nil)
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
(el-get-bundle auto-complete)
(el-get-bundle coffee-mode)
(el-get-bundle color-theme)
(el-get-bundle color-theme-solarized)
(el-get-bundle company-go)
(el-get-bundle dash)
(el-get-bundle dockerfile-mode)
(el-get-bundle elpa:ruby-electric)
(el-get-bundle expand-region)
(el-get-bundle flycheck)
(el-get-bundle flycheck-pos-tip)
(el-get-bundle flymake-easy)
(el-get-bundle fringe-helper)
(el-get-bundle git-gutter)
(el-get-bundle git-gutter-fringe)
(el-get-bundle go-autocomplete)
(el-get-bundle go-eldoc)
(el-get-bundle go-mode)
(el-get-bundle haml-mode)
(el-get-bundle helm)
(el-get-bundle helm-ag)
(el-get-bundle helm-flycheck)
(el-get-bundle helm-ls-git)
(el-get-bundle json-mode)
(el-get-bundle magit)
(el-get-bundle markdown-mode)
(el-get-bundle markdown-toc)
(el-get-bundle nginx-mode)
(el-get-bundle org-mode)
(el-get-bundle popwin)
(el-get-bundle powerline)
(el-get-bundle rainbow-delimiters)
(el-get-bundle robe)
(el-get-bundle robe-mode)
(el-get-bundle rspec-mode)
(el-get-bundle rubocop)
(el-get-bundle ruby-block)
(el-get-bundle ruby-refactor)
(el-get-bundle slim-mode)
(el-get-bundle smart-compile)
(el-get-bundle visual-regexp)
(el-get-bundle yaml-mode)
(el-get-bundle yascroll)
(el-get-bundle yasnippet)
(el-get-bundle yatex)

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

;; magit
(global-set-key (kbd "C-c m") 'magit-status)

;; keybind
(global-set-key (kbd "C-h") 'left-char)
(global-set-key (kbd "C-j") 'next-line)
(global-set-key (kbd "C-k") 'previous-line)
(global-set-key (kbd "C-l") 'right-char)
(global-set-key (kbd "C-z") 'other-window)

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

;; helm
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)

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
(git-gutter:linum-setup)
(global-git-gutter-mode t)
(global-set-key (kbd "C-x C-g") 'git-gutter)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)
(global-set-key (kbd "C-x v SPC") 'git-gutter:mark-hunk)

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
(require 'ruby-block)
(setq ruby-block-highlight-toggle t)

;; slim
(unless (package-installed-p 'slim-mode)
  (package-refresh-contents) (package-install 'slim-mode))
(add-to-list 'auto-mode-alist '("\\.slim?\\'" . slim-mode))

;; haml
(unless (package-installed-p 'haml-mode)
  (package-refresh-contents) (package-install 'haml-mode))
(add-to-list 'auto-mode-alist '("\\.ha?ml?\\'" . haml-mode))

;; json
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

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


(global-set-key "\M-n" "\C-u1\C-v")
(global-set-key "\M-p" "\C-u1\M-v")

;; golang
(add-hook 'go-mode-hook 'company-mode)
(add-hook 'go-mode-hook 'flycheck-mode)
(add-hook 'go-mode-hook (lambda()
           (add-hook 'before-save-hook' 'gofmt-before-save)
           (local-set-key (kbd "M-.") 'godef-jump)
           (set (make-local-variable 'company-backends) '(company-go))
           (company-mode)
           (setq indent-tabs-mode nil)
           (setq c-basic-offset 4)
           (setq tab-width 4)))

(add-hook 'go-mode-hook 'go-eldoc-setup)
(set-face-attribute 'eldoc-highlight-function-argument nil
                    :underline t :foreground "green"
                    :weight 'bold)
(eval-after-load "go-mode"
  '(progn
     (require 'go-autocomplete)))
(define-key go-mode-map (kbd "C-@") 'godef-jump-other-window)
