class bluemind::rsyslog {
    include rsyslog::imfile

    $conf_dir = $bluemind::vars::rsyslog_conf_dir

    file {
	"Install bluemind rsyslog main configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$bluemind::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/20_bluemind_defaults",
	    require => File["Prepare rsyslog for further configuration"],
	    source  => "puppet:///modules/bluemind/rsyslog";
    }
}
