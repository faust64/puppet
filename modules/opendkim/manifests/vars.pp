class opendkim::vars {
    $conf_dir        = lookup("opendkim_conf_dir")
    $routeto         = lookup("postfix_routeto")
    $runtime_group   = lookup("opendkim_runtime_group")
    $runtime_user    = lookup("opendkim_runtime_user")
    $sign            = lookup("opendkim_sign_domains")
    $trustedhosts    = lookup("opendkim_trusted_hosts")
}
