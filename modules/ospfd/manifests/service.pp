class ospfd::service {
    exec {
	"Reload ospf configuration":
	    command     => "ospf_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Ospf application script"];
    }

    if ($has_ifstated == false) {
	common::define::service {
	    $ospfd::vars::ospf_service_name:
		ensure  => running,
		require => File["Install Ospfd configuration"];
	}
    }
}
