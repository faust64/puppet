class bacula::service {
    if ($bacula::vars::file_daemon_fileset
	or $bacula::vars::director_host == $fqdn) {
	common::define::service {
	    "bacula-fd":
		ensure => running;
	}
    }

    if ($bacula::vars::director_host == $fqdn) {
	common::define::service {
	    "bacula-director":
		ensure => running;
	}
    }

    if ($bacula::vars::storage_host == $fqdn) {
	common::define::service {
	    "bacula-sd":
		ensure => running;
	}
    }
}
