class squid::openbsd {
    common::define::package {
	"squid":
    }

    file {
	"Drop unused folder logs":
	    ensure  => absent,
	    force   => true,
	    path    => "/var/snort/logs",
	    require => Package["squid"];
    }

    Package["squid"]
	-> File["Prepare Squid for further configuration"]
}
