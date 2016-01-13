##Example account.com.EMAILCLIENT.USERNAME file.

###GMAIL
```bash
set from = "EMAIL ADDRESS"
set realname = "FULL NAME"
set imap_user = "EMAIL ADDRESS"
set imap_pass = "PASSWORD"

###REMOTE GMAIL FOLDERS
set folder = "imaps://imap.gmail.com:993"
set spoolfile = "+INBOX"
set postponed ="+[Google Mail]/Drafts"
set trash = "+[Google Mail]/Trash"

###SMTP Settings to sent email
set smtp_url = "smtp://USERNAME@smtp.gmail.com:587/"
set smtp_pass = "PASSWORD"

###LOCAL FOLDERS FOR CACHED HEADERS AND CERTIFICATES
set header_cache =~/.mutt/cache/headers
set message_cachedir =~/.mutt/cache/bodies
set certificate_file =~/.mutt/certificates

set imap_user = "EMAIL ADDRESS"
set imap_pass = "PASSWORD"
set smtp_url = "smtp://USERNAME@smtp.live.com:587/"
set smtp_pass = "PASSWORD"
set from = "EMAIL ADDRESS"
set realname = "FULL NAME"
set folder = "pops://pop3.live.com:995"
set spoolfile = "+INBOX"
set postponed = "+[Hotmail]/Drafts"
set header_cache = ~/.mutt/cache/headers
set message_cachedir = ~/.mutt/cache/bodies
set certificate_file = ~/.mutt/certificates
set ssl_force_tls = yes
```
##OR

###HOTMAIL
```bash
set imap_user = "USERNAME@live.com"
set imap_pass = "PASSWORD"
set smtp_url = "smtp://USERNAME3@live.com@smtp.live.com:587/"
set smtp_pass = "PASSWORD"
set from = "USERNAME@live.com"
set realname = "FULL NAME"
set folder = "imaps://imap-mail.outlook.com:993"
set spoolfile = "+INBOX"
set postponed = "+[Live]/Drafts"
set header_cache = ~/.mutt/cache/headers
set message_cachedir = ~/.mutt/cache/bodies
set certificate_file = ~/.mutt/certificates
set ssl_force_tls = yes
set folder = "imaps://imap-mail.outlook.com:993"
```
