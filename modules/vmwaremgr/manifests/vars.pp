class vmwaremgr::vars {
    $download           = lookup("download_cmd")
    $esx_pass           = lookup("vmwares_esx_passphrase")
    $esx_user           = lookup("vmwares_esx_username")
    $esx_version        = lookup("esx_version")
    $esx_who            = lookup("vmwares_esx_hosts")
    $esx_what           = lookup("vmwares_esx_probes")
    $munin_conf_dir     = lookup("munin_conf_dir")
    $munin_service_name = lookup("munin_node_service_name")
    $repo               = lookup("puppet_http_repo")
}
