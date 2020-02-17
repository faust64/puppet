class airsonic::rsyslog {
    include rsyslog::imfile

    $conf_dir = $airsonic::vars::rsyslog_conf_dir

    file {
	"Install airsonic rsyslog main configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$airsonic::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/06_airsonic.conf",
	    require => File["Prepare rsyslog for further configuration"],
	    source  => "puppet:///modules/airsonic/rsyslog";
    }
}
