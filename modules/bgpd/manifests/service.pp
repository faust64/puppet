class bgpd::service {
    exec {
	"Reload bgp configuration":
	    command     => "bgp_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Bgp application script"];
    }

    common::define::service {
	$bgpd::vars::bgp_service_name:
	    ensure  => running,
	    require => File["Install Bgpd configuration"];
    }
}
