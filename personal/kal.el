;; package-list-packages
;; - paredit
;; - nrepl / cider
;; - deft

;;--------------------------------------------------
;; counteract prelude

(disable-theme 'zenburn)

(setq scroll-margin 0
      scroll-conservatively 0
      scroll-preserve-screen-position t)

(setq prelude-flyspell nil)

;; flx/ido - from - https://github.com/lewang/flx
(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

;;--------------------------------------------------
;; colors

(custom-set-faces
 '(default ((t (:foreground "grey" :background "black"))))
 '(erc-prompt-face ((t (:background "black" :foreground "lightblue" :weight bold)))))

;; -- (set-default-font "Consolas 14")

(set-cursor-color "yellow")

(global-hl-line-mode t)
(set-face-background 'hl-line "#113")

(add-hook 'clojure-mode-hook 'paredit-mode)
(add-hook 'nrepl-mode-hook 'paredit-mode)

(eval-after-load "magit"
  ;; no highlight
  '(defun magit-highlight-section ()))

;;--------------------------------------------------
;; other

(setq include-path (expand-file-name "~/.emacs.d/personal/"))
(add-to-list 'load-path include-path)

;; deft
(add-to-list 'load-path (concat include-path "deft"))
(require 'deft)
(setq deft-extension "txt")
(setq deft-directory (concat include-path "deft-files"))
(setq deft-text-mode 'org-mode)
(setq deft-auto-save-interval 30.0)
(defun kill-all-deft-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
        (set-buffer buffer)
        (when (or (string-match "^deft-[[:digit:]]*\.txt$"
                                (buffer-name buffer))
                  (string= "*Deft*" (buffer-name buffer)))
          (kill-buffer buffer)
          (setq count (1+ count))))
      (message "Killed %i deft buffer(s)." count))))
(global-set-key [f6] 'deft)
(global-set-key [(control f6)] 'kill-all-deft-buffers)

;; dired
(put 'dired-find-alternate-file 'disabled nil)
(defun kill-all-dired-buffers()
  "Kill all dired buffers."
  (interactive)
  (save-excursion
    (let((count 0))
      (dolist(buffer (buffer-list))
        (set-buffer buffer)
        (when (equal major-mode 'dired-mode)
          (setq count (1+ count))
          (kill-buffer buffer)))
      (message "Killed %i dired buffer(s)." count))))
(global-set-key [f5] 'dired)
(global-set-key [(control f5)] 'kill-all-dired-buffers)

;;--------------------------------------------------
;; key bindings

(defvar my-keys-minor-mode-map (make-keymap) "my-keys-minor-mode keymap.")

;; frame switching
(define-key my-keys-minor-mode-map [\C-tab] 'other-window) ;; next-multiframe-window
;; dumb autocompletion
(define-key my-keys-minor-mode-map (kbd "C-<return>" ) 'dabbrev-expand)
;; frame resize
(define-key my-keys-minor-mode-map (kbd "S-C-<left>" ) 'shrink-window-horizontally)
(define-key my-keys-minor-mode-map (kbd "S-C-<right>") 'enlarge-window-horizontally)
(define-key my-keys-minor-mode-map (kbd "S-C-<down>" ) 'shrink-window)
(define-key my-keys-minor-mode-map (kbd "S-C-<up>"   ) 'enlarge-window)
;; window config (re)store
(define-key my-keys-minor-mode-map (kbd "C-1") (lambda () (interactive) (window-configuration-to-register 49)))
(define-key my-keys-minor-mode-map (kbd "C-2") (lambda () (interactive) (window-configuration-to-register 50)))
(define-key my-keys-minor-mode-map (kbd "C-3") (lambda () (interactive) (window-configuration-to-register 51)))
(define-key my-keys-minor-mode-map (kbd "C-4") (lambda () (interactive) (window-configuration-to-register 52)))
(define-key my-keys-minor-mode-map (kbd "M-1") (lambda () (interactive) (jump-to-register 49)))
(define-key my-keys-minor-mode-map (kbd "M-2") (lambda () (interactive) (jump-to-register 50)))
(define-key my-keys-minor-mode-map (kbd "M-3") (lambda () (interactive) (jump-to-register 51)))
(define-key my-keys-minor-mode-map (kbd "M-4") (lambda () (interactive) (jump-to-register 52)))

(define-minor-mode my-keys-minor-mode
  "A minor mode so that my key settings override annoying major modes."
  t " my-keys" 'my-keys-minor-mode-map)

(my-keys-minor-mode 1)

;; turn off keybindings in minibuffer
(defun my-minibuffer-setup-hook ()
  (my-keys-minor-mode 0))
(add-hook 'minibuffer-setup-hook 'my-minibuffer-setup-hook)

