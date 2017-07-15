class sendmail::vars {
    $accept_domains = lookup("sendmail_accept_domains")
    $alias_dir      = lookup("mail_alias_dir")
    $mail_ip        = lookup("mail_ip")
    $mail_mx        = lookup("mail_mx")
    $mail_recipient = lookup("mail_recipient")
}
