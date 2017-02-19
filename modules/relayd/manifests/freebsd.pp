class ospfd::freebsd {
    common::define::package {
	"relayd":
    }

    file {
	"Enable relayd service":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["relayd"],
	    owner   => root,
	    path    => "/etc/rc.conf.d/relayd",
	    require =>
		[
		    Package["relayd"],
		    File["Prepare FreeBSD services configuration directory"]
		],
	    source  => "puppet:///modules/relayd/freebsd.rc";
    }
}
