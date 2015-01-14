;;; pytest.el --- Easy Python test running in Emacs

;; Copyright (C) 2015 Eric Larson

;; Licensed under the same terms as Emacs.

;; Version: 0.1.0
;; Keywords: sysadmin eshell
;; URL: https://github.com/ionrock/tailel
;; Created: 2015-01-14

;; This file is NOT part of GNU Emacs.

;; Licensed under the same terms as Emacs.

;;; Commentary:
;; Some helpers and interactive functions to easily tail files and
;; command output.


(defun tailel-create-buffer-name (cmd)
  (format "*tail: %s*" cmd))

(defun tailel-tail-command (cmd)
  "Tail a file in its own buffer."
  (let ((buffer-namer  (lambda (mode)
			 (tailel-create-buffer-name cmd))))
    (compilation-start cmd nil buffer-namer)))

(defun tailel-tail-ssh-command (user host cmd)
  (let ((ssh-cmd (format "ssh %s@%s %s" user host cmd)))
    (tailel-tail-command ssh-cmd)))
