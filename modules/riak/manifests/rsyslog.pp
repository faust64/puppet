class riak::rsyslog {
    include rsyslog::imfile

    $conf_dir = $riak::vars::rsyslog_conf_dir
    $version  = $riak::vars::rsyslog_version

    file {
	"Install riak rsyslog main configuration":
	    content => template("riak/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$riak::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/16_riak_defaults.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
