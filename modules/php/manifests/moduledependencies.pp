class php::moduledependencies {
    if ($php::vars::php_pear == true) {
	common::define::package {
	    "php-pear":
	}
    }
    if ($php::vars::mod_ctype == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php5-ctype":
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
		"php5-curl":
	    }
	}
    }
    if ($php::vars::mod_dom == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php5-dom":
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
		"php5-ftp":
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
		"php5-gd":
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
		"php5-gettext":
	    }
	}
    }
    if ($php::vars::mod_gmp == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php5-gmp":
	    }
	}
    }
    if ($php::vars::mod_intl == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php5-intl":
	    }
	}
    }
    if ($php::vars::mod_json == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-jsonlint":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php-services-json":
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php5-json":
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
		"php5-ldap":
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
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php5-mbstring":
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
	    common::define::package {
		"php5-mcrypt":
	    }
	}
    }
    if ($php::vars::mod_memcache == true) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-memcache":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php5-memcache":
	    }
	}
    }
    if ($php::vars::mod_mysqlnd == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu") {
	    common::define::package {
		"php5-mysqlnd":
	    }
	}
    } elsif ($php::vars::mod_mysql == true or $php::vars::mod_mysqli) {
	if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	    common::define::package {
		"php-mysql":
	    }
	} elsif ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    common::define::package {
		"php5-mysql":
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
		"php5-pgsql":
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
		"php5-snmp":
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
		"php5-sqlite":
	    }
	} elsif ($operatingsystem == "FreeBSD") {
	    common::define::package {
		"php5-sqlite3":
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
		[ "php5-simplexml", "php5-xml" ]:
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
		"php5-xmlrpc":
	    }
	}
    }
    if ($php::vars::php_sessions == true and $operaintgsystem == "FreeBSD") {
	common::define::package {
	    "php5-session":
	}
    }
    if ($php::vars::mod_zlib == true and $operatingsystem == "FreeBSD") {
	common::define::package {
	    "php5-zlib":
	}
    }
    if ($php::vars::mod_pdo == true
	and ($operatingsystem == "CentOS" or $operatingsystem == "RedHat")) {
	common::define::package {
	    "php-pdo":
	}
    }
}
