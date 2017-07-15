class rsyslog::logrotate {
    $srvname = $rsyslog::vars::service_name

    file {
	"Install rsyslog logrotate configuration":
	    content => template("rsyslog/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    owner   => root,
	    path    => "/etc/logrotate.d/$srvname",
	    require => File["Prepare Logrotate for further configuration"];
    }

    if ($srvname != "syslog") {
	file {
	    "Drop misnamed syslog logrotate configuration":
		ensure => absent,
		force  => true,
		path   => "/etc/logrotate.d/syslog";
	}
    }
}
