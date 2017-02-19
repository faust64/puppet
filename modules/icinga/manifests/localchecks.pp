class icinga::localchecks {
    $check_domains = $icinga::vars::check_domains
    $check_ssl     = $icinga::vars::check_ssl

    if ($check_domains) {
	file {
	    "Install domains check configuration":
		content => template("icinga/check_domains.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Exec["Refresh Icinga configuration"],
		owner   => root,
		path    => "/etc/nagios/import.d/services/domains_$fqdn.cfg",
		require => File["Prepare nagios services probes import directory"],
	}
    } else {
	file {
	    "Purge domains check configuration":
		ensure  => absent,
		notify  => Exec["Refresh Icinga configuration"],
		path    => "/etc/nagios/import.d/services/domains_$fqdn.cfg";
	}
    }

    if ($check_ssl) {
	include common::libs::perljson
	include common::libs::perlwww

	file {
	    "Install ssl check configuration":
		content => template("icinga/check_ssl.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Exec["Refresh Icinga configuration"],
		owner   => root,
		path    => "/etc/nagios/import.d/services/ssl_$fqdn.cfg",
		require => File["Prepare nagios services probes import directory"],
	}
    } else {
	file {
	    "Purge ssl check configuration":
		ensure  => absent,
		notify  => Exec["Refresh Icinga configuration"],
		path    => "/etc/nagios/import.d/services/ssl_$fqdn.cfg";
	}
    }
}
