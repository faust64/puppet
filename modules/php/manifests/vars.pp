class php::vars {
    $check_cli            = lookup("php_is_cli")
    $check_fpm            = lookup("php_is_fpm")
    $cmod_mysql           = lookup("php_mod_mysql")
    $cmod_mysqli          = lookup("php_mod_mysqli")
    $cmod_mysqlnd         = lookup("php_mod_mysqlnd")
    $cphp_pear            = lookup("php_pear")
    $cmod_xml             = lookup("php_mod_xml")
    $conf_dir             = lookup("php_conf_dir")
    $cwith_dev            = lookup("php_with_dev")
    $disabled_functions   = lookup("php_disabled_functions")
    $errfilter            = lookup("php_error_report")
    $gc_probability       = lookup("php_gc_probability")
    $hashbitsperchar      = lookup("php_hashbits_per_character")
    $listen_ports         = lookup("apache_listen_ports")
    $mail_ip              = lookup("mail_ip")
    $mail_mx              = lookup("mail_mx")
    $max_exectime         = lookup("php_max_exectime")
    $mem_limit            = lookup("php_memory_limit")
    $mod_bcmath           = lookup("php_mod_bcmath")
    $mod_ctype            = lookup("php_mod_ctype")
    $mod_curl             = lookup("php_mod_curl")
    $mod_dom              = lookup("php_mod_dom")
    $mod_ftp              = lookup("php_mod_ftp")
    $mod_gd               = lookup("php_mod_gd")
    $mod_gettext          = lookup("php_mod_gettext")
    $mod_gmp              = lookup("php_mod_gmp")
    $mod_fileinfo         = lookup("php_mod_fileinfo")
    $mod_iconv            = lookup("php_mod_iconv")
    $mod_intl             = lookup("php_mod_intl")
    $mod_json             = lookup("php_mod_json")
    $mod_ldap             = lookup("php_mod_ldap")
    $mod_ldap_pecl        = lookup("php_mod_ldap_pecl")
    $mod_mbstring         = lookup("php_mod_mbstring")
    $mod_mcrypt           = lookup("php_mod_mcrypt")
    $mod_memcache         = lookup("php_mod_memcache")
    $mod_pdo_check        = lookup("php_mod_pdo")
    $mod_pgsql            = lookup("php_mod_pgsql")
    $mod_phar             = lookup("php_mod_phar")
    $mod_snmp             = lookup("php_mod_snmp")
    $mod_sqlite           = lookup("php_mod_sqlite")
    $mod_uploadprogress   = lookup("php_mod_uploadprogress")
    $mod_xmlreader        = lookup("php_mod_xmlreader")
    $mod_xmlrpc           = lookup("php_mod_xmlrpc")
    $mod_xmlwriter        = lookup("php_mod_xmlwriter")
    $mod_xsl              = lookup("php_mod_xsl")
    $mod_zip              = lookup("php_mod_zip")
    $mod_zlib             = lookup("php_mod_zlib")
    $munin_apache         = lookup("apache_munin")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("php_munin")
    $munin_nginx          = lookup("nginx_munin")
    $munin_probes         = lookup("php_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $php_sessions         = lookup("php_explicit_sessions")
    $post_max             = lookup("php_post_max_size")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $serialize_precision  = lookup("php_serialize_precision")
    $tzdata               = lookup("locale_tz")
    $upload_max           = lookup("php_upload_max_filesize")
    $web_root             = lookup("apache_web_root")
    $with_apc             = lookup("php_apc")
    $zend_modules         = lookup("php_zend_extensions")

    if (($operatingsystem == "Debian" and $lsbdistcodename == "stretch") or ($operatingsystem == "Ubuntu" and $lsbdistcodename == "xenial")) {
	$phpvers = "7.0"
    } elsif ($operatingsystem == "Debian" and $lsbdistcodename == "buster") {
	$phpvers = "7.3"
    } else {
	$phpvers = "5"
    }

    if ($phpvers == "5") {
	$mod_mysql   = $cmod_mysql
	$mod_mysqli  = $cmod_mysqli
	$mod_mysqlnd = $cmod_mysqlnd
	$mod_xml     = $cmod_xml
    } else {
	$mod_mysql = false
	if ($cmod_mysql == true) {
	    notify { "mod_mysql no longer available as of php7": }
	    $mod_mysqli  = true
	} else {
	    $mod_mysqli  = $cmod_mysqli
	}
	if ($mod_mysqli == true) {
	    $mod_mysqlnd = true
	} else {
	    $mod_mysqlnd = $cmod_mysqlnd
	}
	if ($mod_mcrypt == true) {
	    $mod_xml = true
	} else {
	    $mod_xml = $cmod_xml
	}
    }

    if ($mod_mysql or $mod_mysqli or $mod_mysqlnd) {
	$mod_pdo_mysql = true
    } else {
	$mod_pdo_mysql = false
    }
    if ($mod_pdo_mysql or $mod_sqlite) {
	$mod_pdo = true
    } else {
	$mod_pdo = $mod_pdo_check
    }
    if ($check_cli == true) {
	$is_cli  = true
	$is_fpm  = false
	$srvname = false
    } elsif ($check_fpm == true or defined(Class[Nginx])) {
	$is_cli  = false
	$is_fpm  = true
	case $myoperatingsystem {
	    "CentOS", "RedHat": {
		$srvname = "php-fpm"
	    }
	    "Debian", "Devuan", "Ubuntu": {
		$srvname = "php${phpvers}-fpm"
	    }
	}
    } else {
	$is_cli  = false
	$is_fpm  = false
	$srvname = false
    }
    if ($php::vars::mod_mcrypt == true) {
	if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
	    or $operatingsystem == "Ubuntu" or $operatingsystem == "FreeBSD") {
	    if ($lsbdistcodename == "buster" or $lsbdistcodename == "stretch"
		or $lsbdistcodename == "ascii" or $lsbdistcodename == "beowulf") {
		$php_pear = true
		$with_dev = true
	    } else {
		$php_pear = $cphp_pear
		$with_dev = $cwith_dev
	    }
	} else {
	    $php_pear = $cphp_pear
	    $with_dev = $cwith_dev
	}
    } else {
	$php_pear = $cphp_pear
	$with_dev = $cwith_dev
    }
}
