class peerio::vars {
    $admin_name           = hiera("peerio_admin_name")
    $airbrake             = hiera("peerio_airbrake")
    $apt_repo             = hiera("peerio_apt_repo")
    $apt_repo_key         = hiera("peerio_apt_repo_key_author")
    $chunks_dir           = hiera("peerio_chunks_dir")
    $conf_dir             = hiera("peerio_conf_dir")
    $contact              = hiera("peerio_contact")
    $default_locale       = hiera("peerio_default_locale")
    $environ              = hiera("peerio_environment")
    $files_name           = hiera("peerio_files_name")
    $force_fork           = hiera("peerio_force_fork")
    $gidadm               = hiera("gid_adm")
    $hhouse_port          = hiera("peerio_hauntedhouse_port")
    $hhouse_proto         = hiera("peerio_hauntedhouse_proto")
    $inferno_name         = hiera("peerio_inferno_name")
    $inferno_tor          = hiera("peerio_inferno_tor")
    $logs_dir             = hiera("peerio_logs_dir")
    $mailfrom             = hiera("peerio_mailfrom")
    $mailrelay_check      = hiera("mail_mx")
    $mailreplyto          = hiera("peerio_mailreplyto")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("peerio_munin")
    $munin_probesadm      = hiera("peerio_munin_admin_probes")
    $munin_probesbg       = hiera("peerio_munin_background_probes")
    $munin_probesfg       = hiera("peerio_munin_foreground_probes")
    $munin_probesshark    = hiera("peerio_munin_shark_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $nagios_runtime_user  = hiera("nagios_runtime_user")
    $nagios_plugins_dir   = hiera("nagios_plugins_dir")
    $nuts_name            = hiera("peerio_nuts_name")
    $nuts_repo            = hiera("peerio_nuts_repository")
    $redis_backends       = hiera("peerio_redis_backends")
    $redis_elcname        = hiera("peerio_redis_elasticache")
    $redis_limit          = hiera("peerio_redis_limit")
    $redis_munin_probes   = hiera("redis_munin_probes")
    $riak_backends        = hiera("peerio_riak_backends")
    $riak_health          = hiera("peerio_riak_health_auth")
    $riak_lb              = hiera("peerio_riak_is_balanced")
    $riak_max_cpn         = hiera("peerio_riak_max_connections_per_node")
    $riak_min_cpn         = hiera("peerio_riak_min_connections_per_node")
    $riak_ssl             = hiera("peerio_riak_ssl")
    $riak_user            = hiera("peerio_riak_user")
    $rotate               = hiera("peerio_logs_rotate")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $runtime_group        = hiera("peerio_runtime_group")
    $runtime_user         = hiera("peerio_runtime_user")
    $shark_dbhost         = hiera("peerio_shark_dbhost")
    $shark_dbmaxcon       = hiera("peerio_shark_dbmaxcon")
    $shark_dbname         = hiera("peerio_shark_dbname")
    $shark_dbpass         = hiera("peerio_shark_dbpass")
    $shark_dbuser         = hiera("peerio_shark_dbuser")
    $shark_name           = hiera("peerio_shark_name")
    $shark_port           = hiera("peerio_shark_port")
    $shark_proto          = hiera("peerio_shark_proto")
    $shark_secret         = hiera("peerio_shark_secret")
    $shark_stores         = hiera("peerio_shark_stores")
    $slack_hook           = hiera("peerio_slack_hook")
    $sns                  = hiera("peerio_sns")
    $statsd               = hiera("peerio_statsd")
    $storage              = hiera("peerio_storage")
    $sudo_conf_dir        = hiera("sudo_conf_dir")
    $throttle             = hiera("peerio_throttle")
    $twilio               = hiera("peerio_twilio")
    $website_name         = hiera("peerio_website_name")
    $workers              = hiera("peerio_runtime_processes")
    $ws_name              = hiera("peerio_ws_name")
    $zendesk              = hiera("peerio_zendesk")

    if (defined(Class[Postfix])) {
	$mailrelay = "127.0.0.1"
    } else {
	$mailrelay = $relay_check
    }
}
