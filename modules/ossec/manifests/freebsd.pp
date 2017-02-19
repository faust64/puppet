class ossec::freebsd {
    if ($ossec::vars::manager == false) {
	$pkgname = "ossec-hids-server"

	Package[$pkgname]
	    -> File["Install ossec-authd service script"]
    } else {
	$manager = $ossec::vars::manager
	$pkgname = "ossec-hids-client"

	Package[$pkgname]
	    -> Exec["OSSEC register to $manager"]
    }

    common::define::package {
	$pkgname:
    }

    common::define::lined {
	"Enable OSSEC service":
	    line   => 'ossechids_enable="YES"',
	    match  => '^ossechids_enable=',
	    notify => Service[$ossec::vars::service_name],
	    path   => "/etc/rc.conf";
    }

    Package[$pkgname]
	-> Common::Define::Lined["Enable OSSEC service"]
	-> File["Install ossec main configuration"]
}
