class bacula::rhel {
    common::define::package {
#	[ "bacula-libs", "gdb" ]:
	[ "bacula-common", "gdb" ]:
    }

    if ($bacula::vars::file_daemon_fileset
	or $bacula::vars::director_host == $fqdn) {
	common::define::package {
	    "bacula-client":
	}

	Common::Define::Package["bacula-client"]
	    -> Common::Define::Service["bacula-fd"]
    }

    if ($bacula::vars::director_host == $fqdn) {
	common::define::package {
	    [ "bacula-console", "bacula-director-mysql", "bacula-director-common" ]:
	}

	Common::Define::Package["bacula-director-mysql"]
	    -> Mysql::Define::Create_database["bacula"]
	    -> Common::Define::Service["bacula-director"]
    }

    if ($bacula::vars::storage_host == $fqdn) {
	common::define::package {
	    "bacula-storage-common":
	}

	Common::Define::Package["bacula-storage-common"]
	    -> Common::Define::Service["bacula-sd"]
    }

    Package["bacula-common"]
	-> File["Install bacula logrotate configuration"]
	-> File["Prepare Bacula for further configuration"]
}
