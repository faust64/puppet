class php::modules {
    include php::moduledependencies

    if ($lsbdistcodename == "jessie") {
	php::define::module {
	    "apcu":
		modstatus => $php::vars::with_apc;
	    [ "sqlite3", "pdo_sqlite" ]:
		modstatus => $php::vars::mod_sqlite;
	    [ "apc", "mbstring", "xml", "simplexml" ]:
		modstatus => "purge";
	}
    } else {
	if ($lsbdistcodename == "buster") {
	    php::define::module {
		"posix":
		    modstatus => true;
		"xml":
		    modpriority => 15,
		    modstatus   => $php::vars::mod_xml;
	    }
	} else {
	    php::define::module {
		"posix":
		    modstatus => true;
		"xml":
		    modstatus   => $php::vars::mod_xml;
	    }
	}

	php::define::module {
	    "apc":
		modstatus => $php::vars::with_apc;
	    "mbstring":
		modstatus   => $php::vars::mod_mbstring;
	    [ "sqlite", "pdo_sqlite" ]:
		modstatus   => $php::vars::mod_sqlite;
	    "simplexml":
		modstatus   => $php::vars::mod_xml;
	}
    }

    php::define::module {
	"ctype":
	    modstatus   => $php::vars::mod_ctype;
	"curl":
	    modstatus   => $php::vars::mod_curl;
	"dom":
	    modstatus   => $php::vars::mod_dom;
	"fileinfo":
	    modstatus   => $php::vars::mod_fileinfo;
	"ftp":
	    modstatus   => $php::vars::mod_ftp;
	"gd":
	    modstatus   => $php::vars::mod_gd;
	"gettext":
	    modstatus   => $php::vars::mod_gettext;
	"gmp":
	    modstatus   => $php::vars::mod_gmp;
#	"impl":
#	    modstatus   => $php::vars::mod_impl;
	"json":
	    modstatus   => $php::vars::mod_json;
	"ldap":
	    modstatus   => $php::vars::mod_ldap;
	"mcrypt":
	    modstatus   => $php::vars::mod_mcrypt;
	"memcache":
	    modsource   => "memcache",
	    modstatus   => $php::vars::mod_memcache;
	"mysql":
	    modstatus   => $php::vars::mod_mysql;
	"mysqli":
	    modstatus   => $php::vars::mod_mysqli;
	"mysqlnd":
	    modpriority => 10,
	    modstatus   => $php::vars::mod_mysqlnd;
	"pdo":
	    modpriority => 10,
	    modstatus   => $php::vars::mod_pdo;
	"pdo_mysql":
	    modstatus   => $php::vars::mod_pdo_mysql;
	"pgsql":
	    modstatus   => $php::vars::mod_pgsql;
	"phar":
	    modstatus   => $php::vars::mod_phar;
	"session":
	    modstatus   => $php::vars::php_sessions;
	"snmp":
	    modstatus   => $php::vars::mod_snmp;
	"uploadprogress":
	    modstatus   => $php::vars::mod_uploadprogress;
	"xmlreader":
	    modstatus   => $php::vars::mod_xmlreader;
	"xmlrpc":
	    modstatus   => $php::vars::mod_xmlrpc;
	"xsl":
	    modstatus   => $php::vars::mod_xsl;
	"zip":
	    modstatus   => $php::vars::mod_zip;
	"zlib":
	    modstatus   => $php::vars::mod_zlib;
    }
}
