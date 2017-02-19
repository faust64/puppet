class peerio::config {
    $admin_name     = $peerio::vars::admin_name
    $airbrake       = $peerio::vars::airbrake
    $chunks_dir     = $peerio::vars::chunks_dir
    $conf_dir       = $peerio::vars::conf_dir
    $contact        = $peerio::vars::contact
    $default_locale = $peerio::vars::default_locale
    $environ        = $peerio::vars::environ
    $files_name     = $peerio::vars::files_name
    $force_fork     = $peerio::vars::force_fork
    $hhouse_port    = $peerio::vars::hhouse_port
    $hhouse_proto   = $peerio::vars::hhouse_proto
    $inferno_name   = $peerio::vars::inferno_name
    $inferno_tor    = $peerio::vars::inferno_tor
    $logs_dir       = $peerio::vars::logs_dir
    $mailfrom       = $peerio::vars::mailfrom
    $mailrelay      = $peerio::vars::mailrelay
    $mailreplyto    = $peerio::vars::mailreplyto
    $nuts_name      = $peerio::vars::nuts_name
    $nuts_repo      = $peerio::vars::nuts_repo
    $redis_backends = $peerio::vars::redis_backends
    $redis_elcname  = $peerio::vars::redis_elcname
    $redis_limit    = $peerio::vars::redis_limit
    $riak_backends  = $peerio::vars::riak_backends
    $riak_health    = $peerio::vars::riak_health
    $riak_lb        = $peerio::vars::riak_lb
    $riak_max_cpn   = $peerio::vars::riak_max_cpn
    $riak_min_cpn   = $peerio::vars::riak_min_cpn
    $riak_ssl       = $peerio::vars::riak_ssl
    $riak_user      = $peerio::vars::riak_user
    $runtime_group  = $peerio::vars::runtime_group
    $runtime_user   = $peerio::vars::runtime_user
    $shark_dbhost   = $peerio::vars::shark_dbhost
    $shark_dbmaxcon = $peerio::vars::shark_dbmaxcon
    $shark_dbname   = $peerio::vars::shark_dbname
    $shark_dbpass   = $peerio::vars::shark_dbpass
    $shark_dbuser   = $peerio::vars::shark_dbuser
    $shark_name     = $peerio::vars::shark_name
    $shark_port     = $peerio::vars::shark_port
    $shark_proto    = $peerio::vars::shark_proto
    $shark_secret   = $peerio::vars::shark_secret
    $shark_stores   = $peerio::vars::shark_stores
    $slack_hook     = $peerio::vars::slack_hook
    $sns            = $peerio::vars::sns
    $statsd         = $peerio::vars::statsd
    $storage        = $peerio::vars::storage
    $throttle       = $peerio::vars::throttle
    $twilio         = $peerio::vars::twilio
    $website_name   = $peerio::vars::website_name
    $workers        = $peerio::vars::workers
    $ws_name        = $peerio::vars::ws_name
    $zendesk        = $peerio::vars::zendesk

    file {
	"Prepare Peerio for further configuration":
	    ensure  => directory,
	    group   => $runtime_group,
	    mode    => "0750",
	    owner   => $runtime_user,
	    path    => $conf_dir;
	"Install Peerio main configuration":
	    content => template("peerio/profile.erb"),
	    group   => $runtime_group,
	    mode    => "0640",
	    owner   => $runtime_user,
	    path    => "$conf_dir/.profile",
	    require => File["Prepare Peerio for further configuration"];
    }
}
