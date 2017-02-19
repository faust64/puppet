class mrtg::debian {
    common::define::package {
	"mrtg":
    }

    file {
	"Purge unused mrtg cron":
	    ensure  => absent,
	    force   => true,
	    path    => "/etc/cron.d/mrtg",
	    require => Package["mrtg"];
    }
}
