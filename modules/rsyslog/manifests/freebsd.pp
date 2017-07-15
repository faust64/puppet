class rsyslog::freebsd {
    $srvname = $rsyslog::vars::service_name

    common::define::package {
	"rsyslog":
    }

    file {
	"Enable rsyslog service":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$srvname],
	    owner   => root,
	    path    => "/etc/rc.conf.d/$srvname",
	    require =>
		[
		    Package["rsyslog"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/rsyslog/freebsd.rc";
    }
}
