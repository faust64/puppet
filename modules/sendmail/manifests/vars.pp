class sendmail::vars {
    $accept_domains = hiera("sendmail_accept_domains")
    $alias_dir      = hiera("mail_alias_dir")
    $mail_ip        = hiera("mail_ip")
    $mail_mx        = hiera("mail_mx")
    $mail_recipient = hiera("mail_recipient")
}
