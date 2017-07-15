class subsonic::rsyslog {
    include rsyslog::imfile

    $conf_dir = $subsonic::vars::rsyslog_conf_dir

    file {
	"Install subsonic rsyslog main configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$subsonic::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/06_subsonic.conf",
	    require => File["Prepare rsyslog for further configuration"],
	    source  => "puppet:///modules/subsonic/rsyslog";
    }
}
