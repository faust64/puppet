class opendkim::vars {
    $conf_dir        = hiera("opendkim_conf_dir")
    $routeto         = hiera("postfix_routeto")
    $runtime_group   = hiera("opendkim_runtime_group")
    $runtime_user    = hiera("opendkim_runtime_user")
    $sign            = hiera("opendkim_sign_domains")
    $trustedhosts    = hiera("opendkim_trusted_hosts")
}
