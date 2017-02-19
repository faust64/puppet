class tor::vars {
    $accept       = hiera("tor_accept_networks")
    $data_dir     = hiera("tor_data_dir")
    $gid_adm      = hiera("gid_adm")
    $runtime_user = hiera("tor_runtime_user")
}
