;;; meib-permission.el --- MEIB permission command.

;;; Commentary:
;; TODO:
;;
;; o Perhaps make `meib-permission-users' have a default field? IF
;;   that's possible.

;;; Code:

(defgroup meib-permission nil
  "MEIB permission command."
  :prefix "meib-permission-"
  :group 'meib)

(defcustom meib-permission-users
  '(("user" . "is X, therefore has no permission to speak."))
  "The users that have (or don't have) a permission to speak.
The permissions are in the form (USER DESCRIBING-PHRASE)."
  :group 'meib-permission
  :type '(repeat (cons :tag "Permission" (string :tag "Name")
		       (string :tag "Phrase used to describe the person"))))

(defcustom meib-permission-default
  "is someone I don't know, therefore has no permission to speak."
  "The default descriptor of an user not in
`meib-permission-users.'"
  :group 'meib-permission
  :type 'string)

(defun meib-permission (process sender receiver arguments)
  "Checks if someone has a permission to speak.
If no argument is provided, checks if YOU have a permission to
speak."
  (let* ((channel-users (plist-get (cdr (assoc-string receiver (plist-get (cdr (assoc process meib-connected-server-alist)) :channels))) :users))
	 (arg1 (car arguments))
	 (nick-name (meib-nick-name-from-full-name (if arg1 arg1 sender)))
	 (permission (cdr (assoc nick-name meib-permission-users))))
    (meib-privmsg process receiver (format "Checking if %s has a permission to speak..." (mp nick-name nil t)))
    (meib-privmsg process receiver (format
					"According to my database, %s%s %s" (mp nick-name nil t)
				        (if (member nick-name channel-users) "" " is not here, but")
					(if permission permission meib-permission-default)))))

(provide 'meib-permission)

;;; meib-permission.el ends here
