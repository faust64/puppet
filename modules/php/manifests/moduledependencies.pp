class php::moduledependencies {
    $phpvers = $php::vars::phpvers

    if ($php::vars::php_pear == true) {
	common::define::package {
	    "php-pear":
	}
    }
    if ($php::vars::mod_ctype == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php${phpvers}-ctype":
	}
    }
    if ($php::vars::mod_bcmath == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-bcmath":
	    }
	}
    }
    if ($php::vars::mod_curl == true) {
	include curl

	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-curl":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-curl":
	    }
	}
    }
    if ($php::vars::mod_dom == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php${phpvers}-dom":
	}
    }
    if ($php::vars::mod_ftp == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php-net-ftp":
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-ftp":
	    }
	}
    }
    if ($php::vars::mod_gd == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-gd":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-gd":
	    }
	}
    }
    if ($php::vars::mod_gettext == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-php-gettext":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php-gettext":
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-gettext":
	    }
	}
    }
    if ($php::vars::mod_gmp == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php${phpvers}-gmp":
	    }
	}
    }
    if ($php::vars::mod_intl == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php${phpvers}-intl":
	    }
	}
    }
    if ($php::vars::mod_json == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-jsonlint":
	    }
	} elsif ($operatingsystem == "FreeBSD" or
	    ($operatingsystem == "Debian" and $lsbdistcodename == "buster")) {
	    common::define::package {
		"php${phpvers}-json":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php-services-json":
	    }
	}
    }
    if ($php::vars::mod_ldap == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-ldap":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-ldap":
	    }
	}
    }
    if ($php::vars::mod_ldap_pecl == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php-net-ldap2":
	    }
	}
    }
    if ($php::vars::mod_mbstring == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-mbstring":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-mbstring":
	    }
	}
    }
    if ($php::vars::mod_mcrypt == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-mcrypt":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    if ($lsbdistcodename == "buster" or $lsbdistcodename == "stretch") {
		include common::tools::gcc
		include common::tools::make

		common::define::package {
		    [ "autoconf", "libc-dev", "pkg-config", "libmcrypt-dev" ]:
		}

		#FIXME: noexec needs to be disabled/re-enabled building this
		#also, would want to cleanup build deps afterwards
		exec {
		    "Install php-mcrypt from PECL":
			command => "echo '' | pecl install mcrypt >pecl-install.out 2>&1",
			creates => "/root/pecl-install.out",
			cwd     => "/root",
			path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
			require =>
			    [
				Common::Define::Package["autoconf"],
				Common::Define::Package["libc-dev"],
				Common::Define::Package["libmcrypt-dev"],
				Common::Define::Package["pkg-config"],
				Class[Common::Tools::Gcc],
				Class[Common::Tools::Make],
				Php::Define::Module["xml"]
			    ];
		}

		Exec["Install php-mcrypt from PECL"]
		    -> Php::Define::Module["mcrypt"]
	    } else {
		common::define::package {
		    "php${phpvers}-mcrypt":
		}
	    }
	}
    }
    if ($php::vars::mod_memcache == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat"
	    or ($operatingsystem == "Debian" and $lsbdistcodename == "buster")) {
	    common::define::package {
		"php-memcache":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-memcache":
	    }
	}
    }
    if ($php::vars::mod_mysqlnd == true) {
	if ($operatingsystem == "Debian" and $lsbdistcodename == "buster") {
	    common::define::package {
		"php${phpvers}-mysql":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php${phpvers}-mysqlnd":
	    }
	}
    } elsif ($php::vars::mod_mysql == true or $php::vars::mod_mysqli) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat"
	    or ($operatingsystem == "Debian" and $lsbdistcodename == "buster")) {
	    common::define::package {
		"php-mysql":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-mysql":
	    }
	}
    }
    if ($php::vars::mod_pgsql == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-pgsql":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-pgsql":
	    }
	}
    }
    if ($php::vars::mod_snmp == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-snmp":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-snmp":
	    }
	}
    }
    if ($php::vars::mod_sqlite == true) {
	include sqlite

#	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
#	    common::define::package {
#		"php-sqlite":
#	    }
#	}
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php${phpvers}-sqlite":
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-sqlite3":
	    }
	}
    }
    if ($php::vars::mod_xml == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-xml":
	    }
	} elsif ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	    if ($lsbdistcodename == "squeeze" or $lsbdistcodename == "wheezy"
		or $lsbdistcodename == "trusty"
		or $lsbdistcodename == "precise") {
		common::define::package {
		    "php-xml-serializer":
		}
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		[ "php${phpvers}-simplexml", "php${phpvers}-xml" ]:
	    }
	}
    }
    if ($php::vars::mod_xmlrpc == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-xmlrpc":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php${phpvers}-xmlrpc":
	    }
	}
    }
    if ($php::vars::php_sessions == true and $operaintgsystem == "FreeBSD") {
	common::define::package {
	    "php${phpvers}-session":
	}
    }
    if ($php::vars::mod_zlib == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php${phpvers}-zlib":
	}
    }
    if ($php::vars::mod_pdo == true
	and ($operatingsystem == "CentOS" or $operatingsystem == "RedHat")) {
	common::define::package {
	    "php-pdo":
	}
    }
}
