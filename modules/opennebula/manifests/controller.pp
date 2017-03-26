class opennebula::controller {
    $ldap_base   = $opennebula::vars::ldap_base
    $ldap_slave  = $opennebula::vars::ldap_slave
    $nebula_vers = $opennebula::vars::version

    common::define::package {
	"opennebula":
    }

    if ($opennebula::vars::db_backend == "mysql") {
	include mysql

	mysql::define::create_database {
	    "opennebula":
		dbpass => $opennebula::vars::db_pass,
		dbuser => $opennebula::vars::db_user;
	}
    }

    if (versioncmp("$nebula_vers", '5.0') <= 0) {
	nfs::define::share {
	    "OpenNebula":
		options => [ "rw", "sync", "no_subtree_check", "root_squash" ],
		path    => "/var/lib/one/",
		require => Common::Define::Package["opennebula"],
		to      => [ "*" ];
	}

	common::define::lined {
	    "Enable OpenNebula ldap authentication":
		line    => '    authn = "default,ssh,x509,ldap,server_cipher,server_x509"',
		match   => "    authn =",
		notify  => Service["opennebula"],
		path    => "/etc/one/oned.conf",
		require => File["Install OpenNebula auth ldap configuration"];
	}
    } elsif ($nebula_public_key) {
	@@file {
	    "Install OneAdmin SSH Public Key":
		content => "$nebula_public_key",
		group   => $opennebula::vars::runtime_group,
		mode    => "0644",
		owner   => $opennebula::vars::runtime_user,
		path    => "/var/lib/one/.ssh/authorized_keys",
		tag     => "nebula-ssh-key";
	}

	common::define::lined {
	    "Enable OpenNebula ldap authentication":
		line    => 'DEFAULT_AUTH = "ldap"',
		match   => "DEFAULT_AUTH = ",
		notify  => Service["opennebula"],
		path    => "/etc/one/oned.conf",
		require => File["Install OpenNebula auth ldap configuration"];
	}
    }

    file {
	"Install OpenNebula auth ldap configuration":
	    content => template("opennebula/auth.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["opennebula"],
	    owner   => root,
	    path    => "/etc/one/auth/ldap_auth.conf",
	    require => Package["opennebula"];
    }

    Exec <<| tag == "nebula-compute-host" |>>

    Common::Define::Package["opennebula"]
	-> Common::Define::Package["opennebula-common"]
}
