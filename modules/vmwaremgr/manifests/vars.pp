class vmwaremgr::vars {
    $download           = hiera("download_cmd")
    $esx_pass           = hiera("vmwares_esx_passphrase")
    $esx_user           = hiera("vmwares_esx_username")
    $esx_version        = hiera("esx_version")
    $esx_who            = hiera("vmwares_esx_hosts")
    $esx_what           = hiera("vmwares_esx_probes")
    $munin_conf_dir     = hiera("munin_conf_dir")
    $munin_service_name = hiera("munin_node_service_name")
    $repo               = hiera("puppet_http_repo")
}
