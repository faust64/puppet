class munin::vars {
    $gid_adm        = lookup("gid_adm")
    $munin_conf_dir = lookup("munin_conf_dir")
    $munin_group    = lookup("munin_group")
    $munin_user     = lookup("munin_user")
    $remote_collect = lookup("munin_collect_domains")
    $rdomain        = lookup("root_domain")
    $web_root       = lookup("apache_web_root")
}
