class subsonic::vars {
    $alerts               = hiera("subsonic_alerts")
    $do_flac              = hiera("subsonic_do_flac")
    $getting_started      = hiera("subsonic_getting_started")
    $ldap_base            = hiera("subsonic_searchuser")
    $ldap_slave           = hiera("openldap_ldap_slave")
    $listen_ports         = hiera("apache_listen_ports")
    $locale               = hiera("locale")
    $max_mem              = hiera("subsonic_allocate")
    $message              = hiera("subsonic_message")
    $maintitle            = hiera("subsonic_title")
    $music_root           = hiera("subsonic_music_root")
    $slack_hook           = hiera("subsonic_slack_hook_uri")
    $rdomain              = hiera("root_domain")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $ssh_port             = hiera("ssh_port")
    $subtitle             = hiera("subsonic_subtitle")
    $sync_bwlimit         = hiera("subsonic_sync_bwlimit")
    $sync_directories     = hiera("subsonic_sync_directories")
}
