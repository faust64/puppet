class mysql::debian {
    if ($mysql::vars::provider == "oracle") {
	common::define::package {
	    "mysql-server":
	}
    } elsif ($mysql::vars::provider == "mariadb") {
	common::define::package {
	    "mariadb-server":
	}

	file {
	    "Install MariaDB debian-sys-maint init script":
		content => template("mysql/init-maria.erb"),
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/usr/local/sbin/init-maria-sys-maint";
	}

	exec {
	    "Install MariaDB debian-sys-maint user":
		command => "init-maria-sys-maint",
		cwd     => "/etc/mysql/mariadb.conf.d",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		require =>
		    [
			Common::Define::Service[$mysql::vars::service_name],
			File["Install MariaDB debian-sys-maint init script"]
		    ],
		unless  => "test -s 90-mysqladmin.cnf";
	}
    } else {
	notify { "Invalid provider '$provider'": }
    }
}
