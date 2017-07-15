class syslog::openbsd {
    file {
	"Install kern log file":
	    ensure => present,
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service["syslogd"],
	    owner  => root,
	    path   => "/var/log/kern";
	"Install syslog log file":
	    ensure => present,
	    group  => lookup("gid_zero"),
	    mode   => "0644",
	    notify => Service["syslogd"],
	    owner  => root,
	    path   => "/var/log/syslog";
    }

    include syslog::syslog
}
