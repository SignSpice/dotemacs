;;; -*- no-byte-compile: t -*-

;; This is your user signals file, here you configure how certain signals are
;; handled in specific modes.

;; In this Corgi sample config we've included `js-comint' to demonstrate how
;; that works. This package allows evaluating JavaScript directly from a buffer.
;; Evaluating the expression before the cursor is done in Corgi with `, RET' (or
;; `, e e'), by telling Corgi that in JS buffers this means `js-send-last-sexp'
;; we get the same bindings there.
;;
;; If you prefer some other key binding for "eval", then you can do that in
;; `user-keys.el', and your new binding will do the right thing regardless of
;; the language/mode you are in.

((default ( :command/execute consult-M-x

            :file/open find-file
            :file/save save-buffer
            :file/save-all evil-write-all
            :file/open-recent recentf

            :buffer/switch switch-to-buffer
            :buffer/incremental-search swiper

            :project/open-file projectile-find-file
            :project/switch projectile-switch-project
            :project/kill projectile-kill-buffers
            :project/incremental-search git-grep
            :project/switch-buffer projectile-switch-to-buffer

            :jump/identifier consult-imenu
            :jump/character avy-goto-char
            :jump/last-change goto-last-change

            :help/describe-key describe-key
            :help/describe-variable describe-variable
            :help/describe-function describe-function
            :help/describe-mode describe-mode
            :help/describe-bindings describe-bindings

            :sexp/slurp-forward sp-forward-slurp-sexp
            :sexp/barf-forward sp-forward-barf-sexp
            :sexp/forward evil-cp-forward-sexp
            :sexp/backward evil-cp-backward-sexp

            :toggle/read-only read-only-mode
            :toggle/soft-word-wrap visual-line-mode
            :toggle/hard-word-wrap auto-fill-mode
            :toggle/line-numbers display-line-numbers-mode
            :toggle/aggressive-indent aggressive-indent-mode
            :toggle/debug-on-quit toggle-debug-on-quit
            :toggle/debug-on-error toggle-debug-on-error
            :toggle/completion company-mode))
 (cider-mode (:eval/outer-sexp-comment cider-eval-defun-to-comment)
             (:switch-to-from-cider-repl corgi/switch-to-previous-buffer))
 (cider-repl-mode (:switch-to-from-cider-repl corgi/switch-to-previous-buffer))
 (clojure-mode (:switch-to-from-cider-repl ox/cider-switch-to-repl-buffer-same-window-force))
 (js-mode ( :eval/last-sexp js-send-last-sexp
            :eval/buffer js-send-buffer
            :eval/region js-send-region
            :repl/toggle js-comint-start-or-switch-to-repl))

 ;; (org-mode ( :jump/identifier consult-imenu
 ;;             :jump/character avy-goto-char
 ;;             :jump/last-change consult-imenu)

 ;;           ( :sexp/slurp-forward evil-org->
 ;;             :sexp/barf-forward evil-org-<
 ;;             :sexp/forward org-next-item
 ;;             :sexp/backward org-previous-item))
 )
