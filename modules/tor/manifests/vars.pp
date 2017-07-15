class tor::vars {
    $accept       = lookup("tor_accept_networks")
    $data_dir     = lookup("tor_data_dir")
    $gid_adm      = lookup("gid_adm")
    $runtime_user = lookup("tor_runtime_user")
}
