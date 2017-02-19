class munin::vars {
    $gid_adm        = hiera("gid_adm")
    $munin_conf_dir = hiera("munin_conf_dir")
    $munin_group    = hiera("munin_group")
    $munin_user     = hiera("munin_user")
    $remote_collect = hiera("munin_collect_domains")
    $rdomain        = hiera("root_domain")
    $web_root       = hiera("apache_web_root")
}
