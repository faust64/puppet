class bacula::debian {
    common::define::package {
	[ "bacula-common", "gdb" ]:
    }

    if ($bacula::vars::file_daemon_fileset
	or $bacula::vars::director_host == $fqdn) {
	common::define::package {
	    "bacula-fd":
	}

	Common::Define::Package["bacula-fd"]
	    -> Common::Define::Service["bacula-fd"]

	if (defined(Apt::Define::Repo["backports"])) {
	    Common::Define::Package["bacula-fd"]
		-> Apt::Define::Repo["backports"]
	}
    }

    if ($bacula::vars::director_host == $fqdn) {
	common::define::package {
	    [ "bacula-console", "bacula-common-mysql",
		"bacula-director-mysql", "bacula-director-common" ]:
	}

	Common::Define::Package["bacula-common-mysql"]
	    -> Mysql::Define::Create_database["bacula"]

	Common::Define::Package["bacula-director-mysql"]
	    -> Mysql::Define::Create_database["bacula"]
	    -> Common::Define::Service["bacula-director"]

	if (defined(Apt::Define::Repo["backports"])) {
	    Common::Define::Package["bacula-common-mysql"]
		-> Apt::Define::Repo["backports"]
	    Common::Define::Package["bacula-director"]
		-> Apt::Define::Repo["backports"]
	}
    }

    if ($bacula::vars::storage_host == $fqdn) {
	common::define::package {
	    "bacula-sd":
	}

	Common::Define::Package["bacula-sd"]
	    -> Common::Define::Service["bacula-sd"]

	if (defined(Apt::Define::Repo["backports"])) {
	    Common::Define::Package["bacula-sd"]
		-> Apt::Define::Repo["backports"]
	}
    }

    Package["bacula-common"]
	-> File["Install bacula logrotate configuration"]
	-> File["Prepare Bacula for further configuration"]
}
