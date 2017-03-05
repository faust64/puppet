class common::config::mlocate {
    case $myoperatingsystem {
	"CentOS", "Debian", "Devuan", "RedHat", "Ubuntu": {
	    common::define::package {
		"mlocate":
		    ensure => absent;
	    }

	    Package["mlocate"]
		-> File["Remove mlocate automatic update"]
	}
    }

    file {
	"Remove mlocate automatic update":
	    ensure  => absent,
	    force   => true,
	    path    => "/etc/cron.daily/mlocate";
    }
}
