class cups::freebsd {
    if ($cups::vars::with_hplip) {
	common::define::package {
	    "hplip":
		require => Package["cups-base"];
	}
    }

    common::define::package {
	"cups-base":
    }

    common::define::lined {
	"Enable cups service":
	    line   => 'cupsd_enable="YES"',
	    match  => '^cupsd_enable=',
	    notify => Service[$cups::vars::service_name],
	    path   => "/etc/rc.conf";
    }

    Package["cups-base"]
	-> File["Prepare cups for further configuration"]
	-> Common::Define::Lined["Enable cups service"]
	-> Service[$cups::vars::service_name]
}
