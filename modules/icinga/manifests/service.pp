class icinga::service {
    exec {
	"Refresh Icinga configuration":
	    command     => "icinga_resync",
	    cwd         => $icinga::vars::conf_dir,
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true;
    }

    common::define::service {
	"icinga":
	    ensure  => running,
	    require => Exec["Refresh Icinga configuration"];
    }
}
