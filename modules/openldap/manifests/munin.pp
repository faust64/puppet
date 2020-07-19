class openldap::munin {
    if ($openldap::vars::munin_probes) {
	if ($openldap::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    include common::libs::perlnetldap

	    $conf_dir = $openldap::vars::munin_conf_dir
	    $pass     = $openldap::vars::munin_ldap_pass
	    $user     = $openldap::vars::munin_ldap_user

	    muninnode::define::probe {
		$openldap::vars::munin_probes:
		    plugin_name => "slapd_",
		    require     => File["Install openldap munin probe configuration"];
	    }

	    file {
		"Install openldap munin probe configuration":
		    content => template("openldap/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$openldap::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/openldap.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }

	    Class["common::libs::perlnetldap"]
		-> File["Install openldap munin probe configuration"]
	} else {
	    muninnode::define::probe {
		$openldap::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
