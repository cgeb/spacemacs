;; Extensions are in emacs_paths/extensions

;; Pre extensions are loaded *before* the packages
(defvar spacemacs-pre-extensions
  '(
    use-package
    solarized-theme
    auto-highlight-symbol
    ))

;; Post extensions are loaded *after* the packages
(defvar spacemacs-post-extensions
  '(
    centered-cursor
    dos
    emoji-cheat-sheet
    evil-org-mode
    evil-plugins
    helm-rcirc
    nose
    o-blog
    pylookup
    spray
    ))

;; Initialize the extensions

(defun spacemacs/init-use-package ()
  (require 'use-package))

(defun spacemacs/init-auto-highlight-symbol ()
  (use-package auto-highlight-symbol
    :commands auto-highlight-symbol-mode
    :init
    (add-to-hooks
     'auto-highlight-symbol-mode '(erlang-mode-hook
                                   prog-mode-hook
                                   org-mode-hook
                                   markdown-mode-hook
                                   ))
    :config
    (progn
      (custom-set-variables
       '(ahs-case-fold-search nil)
       '(ahs-default-range (quote ahs-range-whole-buffer))
       '(ahs-idle-interval 0.5))
      (eval-after-load "evil-leader"
        '(evil-leader/set-key
           "he" 'ahs-edit-mode
           "hn" 'ahs-forward
           "hp" 'ahs-backward
           "th" 'auto-highlight-symbol-mode)))))

(defun spacemacs/init-centered-cursor ()
  (use-package centered-cursor-mode
    :commands global-centered-cursor-mode
    :init
    (evil-leader/set-key "zz" 'global-centered-cursor-mode)
    :config
    (custom-set-variables
     '(ccm-recenter-at-end-of-file t)
     '(ccm-ignored-commands (quote (mouse-drag-region
                                    mouse-set-point
                                    widget-button-click
                                    scroll-bar-toolkit-scroll
                                    evil-mouse-drag-region))))))

(defun spacemacs/init-dos ()
  (use-package dos
    :mode ("\\.bat$" . dos-mode)))

(defun spacemacs/init-emoji-cheat-sheet ()
  (use-package emoji-cheat-sheet
    :commands emoji-cheat-sheet))

(defun spacemacs/init-evil-org-mode ()
  (use-package evil-org
    :commands evil-org-mode
    :init (add-hook 'org-mode-hook 'evil-org-mode)))

(defun spacemacs/init-evil-plugins ()
  (use-package evil-little-word)
  (use-package evil-operator-comment
    :init
    (global-evil-operator-comment-mode 1)))

(defun spacemacs/init-helm-rcirc ()
  (use-package helm-rcirc
    :commands helm-rcirc-auto-join-channels
    :init
    (evil-leader/set-key "irc" 'helm-rcirc-auto-join-channels)))

(defun spacemacs/init-nose ()
  (use-package nose
    :commands (nosetests-one
               nosetests-pdb-one
               nosetests-all
               nosetests-pdb-all
               nosetests-module
               nosetests-pdb-module
               nosetests-suite
               nosetests-pdb-suite)
    :init
    (evil-leader/set-key-for-mode 'python-mode
      "mTf" 'nosetests-pdb-one
      "mtf" 'nosetests-one
      "mTa" 'nosetests-pdb-all
      "mta" 'nosetests-all
      "mTm" 'nosetests-pdb-module
      "mtm" 'nosetests-module
      "mTs" 'nosetests-pdb-suite
      "mts" 'nosetests-suite)
    :config
    (progn
      (add-to-list 'nose-project-root-files "setup.cfg")
      (setq nose-use-verbose nil)
      )))

(defun spacemacs/init-o-blog ()
  (use-package o-blog
    :defer t))

(defun spacemacs/init-pylookup ()
  (use-package pylookup
    :commands pylookup-lookup
    :config
    (progn
      (setq pylookup-dir (concat spacemacs-extensions-directory "/pylookup"))
      ;; set executable file and db file
      (setq pylookup-program (concat pylookup-dir "/pylookup.py"))
      (setq pylookup-db-file (concat pylookup-dir "/pylookup.db")))))

(defun spacemacs/init-revive ()
  (use-package revive
    :disabled t
    :init
    (require 'revive-mode-config)
    :config
    (progn
      ;; save and restore layout
      (add-hook 'kill-emacs-hook 'emacs-save-layout)
      (add-hook 'after-init-hook 'emacs-load-layout t))))

(defun spacemacs/init-spray ()
  (use-package spray
    :commands spray-mode
    :init
    (progn
      (evil-leader/set-key "asp"
        (lambda ()
          (interactive)
          (evil-insert-state)
          (spray-mode t)
          (evil-insert-state-cursor-hide))))
    :config
    (progn
      (define-key spray-mode-map (kbd "h") 'spray-backward-word)
      (define-key spray-mode-map (kbd "l") 'spray-forward-word)
      (define-key spray-mode-map (kbd "q")
        (lambda ()
          (interactive)
          (spray-quit)
          (set-default-evil-insert-state-cursor)
          (evil-normal-state))))))

;; solarized theme dependencies
(unless (package-installed-p 'dash)
  (package-refresh-contents)
  (package-install 'dash))
(defun spacemacs/init-solarized-theme ()
  ;; different method used than the documented one in order to speed up the
  ;; loading of emacs
  (use-package solarized
    :init
    (progn
      (deftheme solarized-dark "The dark variant of the Solarized colour theme")
      (create-solarized-theme 'dark 'solarized-dark)
      (deftheme solarized-light "The light variant of the Solarized colour theme")
      (create-solarized-theme 'light 'solarized-light)
      (spacemacs/post-theme-init 'solarized-light)
      (redisplay))))
