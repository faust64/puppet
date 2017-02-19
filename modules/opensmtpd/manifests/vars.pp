class opensmtpd::vars {
    $alias_dir       = hiera("mail_alias_dir")
    $bin_dir         = hiera("opensmtpd_bin_dir")
    $conf_dir        = hiera("opensmtpd_conf_dir")
    $lib_dir         = hiera("opensmtpd_lib_dir")
    $mail_ip         = hiera("mail_ip")
    $mail_masquerade = hiera("mail_masquerade")
    $mail_recipient  = hiera("mail_recipient")
}
