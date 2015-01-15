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
(require 's)


(defun tailel-create-buffer-name (cmd)
  (format "*tail: %s*" cmd))

(defun tailel-run-command (cmd)
  "Tail a file in its own buffer."
  (let ((buffer-namer  (lambda (mode)
			 (tailel-create-buffer-name cmd))))
    (compilation-start cmd t buffer-namer)))

(defun tailel-run-tail (filename)
  (tailel-run-command (tailel-tail filename)))

(defun tailel-tail (path)
  (format "tail -f %s" path))

(defun tailel-tail-ssh-command (user host cmd)
  (let ((ssh-cmd (format "ssh %s@%s %s" user host cmd)))
    (tailel-run-command ssh-cmd)))

(defun tailel-tail-ssh-dired (filename)
  (save-match-data
    (if (string-match "/scp:\\([^@]+\\)@\\([^@]+\\):\\(.*\\)" filename)
	(let ((user (match-string 1 filename))
	      (host (match-string 2 filename))
	      (cmd (tailel-tail  (match-string 3 filename))))
	(tailel-tail-ssh-command user host cmd)))))

(defun tailel-tail-dired ()
  (interactive)
  (let ((filename (dired-get-filename)))
    (if (s-starts-with? "/scp" filename)
	(tailel-tail-ssh-dired filename)
      (tailel-run-tail filename))))
