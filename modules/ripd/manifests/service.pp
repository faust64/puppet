class ripd::service {
    exec {
	"Reload rip configuration":
	    command     => "rip_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Rip application script"];
    }

    common::define::service {
	$ripd::vars::rip_service_name:
	    ensure  => running,
	    require => File["Install Ripd configuration"];
    }
}
