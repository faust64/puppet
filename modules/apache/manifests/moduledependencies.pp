class apache::moduledependencies {
    $conf_dir        = $apache::vars::conf_dir

    if ($operatingsystem == "CentOS" or $operatingsystem == "FreeBSD" or $operatingsystem == "RedHat") {
	apache::define::module {
	    "log_config":
		modstatus => true;
	}
    }
    if ($apache::vars::mod_fcgid == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-mod-fcgid":
	    }

	    Package["libapache2-mod-fcgid"]
		-> Apache::Define::Module["fcgid"]
	}
    }
    if ($apache::vars::mod_cgid == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"fcgi":
	    }

	    Package["fcgi"]
		-> Apache::Define::Module["cgid"]
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    if ($lsbdistcodename == "buster" or $lsbdistcodename == "stretch"
		or $lsbdistcodename == "beowulf" or $lsbdistcodename == "ascii") {
		notify { "fastcgi no longer available as of stretch": }
		if (! defined(Common::Define::Package["libapache2-mod-fcgid"])) {
		    common::define::package {
			"libapache2-mod-fcgid":
		    }

		    Package["libapache2-mod-fcgid"]
			-> Apache::Define::Module["fcgid"]
		}
	    } else {
		common::define::package {
		    "libapache2-mod-fastcgi":
		}

		apache::define::module {
		    "fastcgi":
			modstatus => $apache::vars::mod_cgid;
		}

		Package["libapache2-mod-fastcgi"]
		    -> Apache::Define::Module["cgid"]

		Package["libapache2-mod-fastcgi"]
		    -> Apache::Define::Module["fastcgi"]
	    }
	}
    }
    if ($apache::vars::mod_mime == true) {
	file {
	    "Install apache MIME magic configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		notify  => Service[$apache::vars::service_name],
		owner   => root,
		path    => "$conf_dir/magic",
		require => File["Prepare Apache for further configuration"],
		source  => "puppet:///modules/apache/magic";
	}
    }
    if ($apache::vars::mod_php == true) {
	include php

	$phpvers = $apache::vars::phpvers
	$phpmaj  = $phpvers.split('\.')[0]

	Class[Php]
	    -> Common::Define::Service[$apache::vars::service_name]

	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-mod-php${phpvers}":
		    require => Package["php${phpvers}"];
	    }

	    Package["libapache2-mod-php${phpvers}"]
		-> Apache::Define::Module["php${phpmaj}"]
	}
    }
    if ($apache::vars::mod_xsendfile == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-mod-xsendfile":
	    }

	    Package["libapache2-mod-xsendfile"]
		-> Apache::Define::Module["xsendfile"]
	} elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"mod_xsendfile":
	    }

	    Package["mod_xsendfile"]
		-> Apache::Define::Module["xsendfile"]
	}
    }
    if ($apache::vars::mod_ldap == true) {
	include openldap::client

	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"mod_authz_ldap":
	    }

	    Package["mod_authz_ldap"]
		-> Apache::Define::Module["ldap"]
		-> Apache::Define::Module["authnz_ldap"]
	}
    }
    if ($apache::vars::listen_ports['ssl'] != false) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"mod_ssl":
	    }

	    Package["mod_ssl"]
		-> Apache::Define::Module["ssl"]
	}
    }
    if ($apache::vars::mod_svn == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"mod_dav_svn":
	    }

	    Package["mod_dav_ssl"]
		-> Apache::Define::Module["dav_svn"]
	}
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-svn":
	    }

	    Package["libapache2-svn"]
		-> Apache::Define::Module["dav_svn"]
	}
    }
    if ($apache::vars::mod_python == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-mod-python":
	    }

	    Package["libapache2-mod-python"]
		-> Apache::Define::Module["python"]
	}
    }
    if ($apache::vars::mod_security == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-modsecurity":
	    }

	    Package["libapache2-modsecurity"]
		-> File["Install mod_security main configuration"]
	} elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"mod_security":
	    }

	    Package["mod_security"]
		-> File["Install mod_security main configuration"]
	}
    }
    if ($apache::vars::mod_wsgi == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"libapache2-mod-wsgi":
	    }

	    Package["libapache2-mod-wsgi"]
		-> Apache::Define::Module["wsgi"]
	}
    }
}
