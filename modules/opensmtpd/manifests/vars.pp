class opensmtpd::vars {
    $alias_dir       = lookup("mail_alias_dir")
    $bin_dir         = lookup("opensmtpd_bin_dir")
    $conf_dir        = lookup("opensmtpd_conf_dir")
    $lib_dir         = lookup("opensmtpd_lib_dir")
    $mail_ip         = lookup("mail_ip")
    $mail_masquerade = lookup("mail_masquerade")
    $mail_recipient  = lookup("mail_recipient")
}
