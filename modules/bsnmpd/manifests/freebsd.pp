class bsnmpd::freebsd {
    file {
	"Enable bsnmpd service":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["bsnmpd"],
	    owner   => root,
	    path    => "/etc/rc.conf.d/bsnmpd",
	    require => File["Prepare FreeBSD services configuration directory"],
	    source  => "puppet:///modules/bsnmpd/freebsd.rc";
    }
}
