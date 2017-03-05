class php::vars {
    $conf_dir             = hiera("php_conf_dir")
    $check_cli            = hiera("php_is_cli")
    $check_fpm            = hiera("php_is_fpm")
    $disabled_functions   = hiera("php_disabled_functions")
    $errfilter            = hiera("php_error_report")
    $gc_probability       = hiera("php_gc_probability")
    $hashbitsperchar      = hiera("php_hashbits_per_character")
    $listen_ports         = hiera("apache_listen_ports")
    $mail_ip              = hiera("mail_ip")
    $mail_mx              = hiera("mail_mx")
    $max_exectime         = hiera("php_max_exectime")
    $mem_limit            = hiera("php_memory_limit")
    $mod_ctype            = hiera("php_mod_ctype")
    $mod_curl             = hiera("php_mod_curl")
    $mod_dom              = hiera("php_mod_dom")
    $mod_ftp              = hiera("php_mod_ftp")
    $mod_gd               = hiera("php_mod_gd")
    $mod_gettext          = hiera("php_mod_gettext")
    $mod_gmp              = hiera("php_mod_gmp")
    $mod_fileinfo         = hiera("php_mod_fileinfo")
    $mod_intl             = hiera("php_mod_intl")
    $mod_json             = hiera("php_mod_json")
    $mod_ldap             = hiera("php_mod_ldap")
    $mod_ldap_pecl        = hiera("php_mod_ldap_pecl")
    $mod_mbstring         = hiera("php_mod_mbstring")
    $mod_mcrypt           = hiera("php_mod_mcrypt")
    $mod_memcache         = hiera("php_mod_memcache")
    $mod_mysql            = hiera("php_mod_mysql")
    $mod_mysqli           = hiera("php_mod_mysqli")
    $mod_mysqlnd          = hiera("php_mod_mysqlnd")
    $mod_pdo_check        = hiera("php_mod_pdo")
    $mod_pgsql            = hiera("php_mod_pgsql")
    $mod_phar             = hiera("php_mod_phar")
    $mod_snmp             = hiera("php_mod_snmp")
    $mod_sqlite           = hiera("php_mod_sqlite")
    $mod_uploadprogress   = hiera("php_mod_uploadprogress")
    $mod_xml              = hiera("php_mod_xml")
    $mod_xmlrpc           = hiera("php_mod_xmlrpc")
    $mod_zip              = hiera("php_mod_zip")
    $mod_zlib             = hiera("php_mod_zlib")
    $munin_apache         = hiera("apache_munin")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("php_munin")
    $munin_nginx          = hiera("nginx_munin")
    $munin_probes         = hiera("php_munin_probes")
    $munin_service_name   = hiera("munin_node_service_name")
    $php_pear             = hiera("php_pear")
    $php_sessions         = hiera("php_explicit_sessions")
    $post_max             = hiera("php_post_max_size")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $serialize_precision  = hiera("php_serialize_precision")
    $tzdata               = hiera("locale_tz")
    $upload_max           = hiera("php_upload_max_filesize")
    $web_root             = hiera("apache_web_root")
    $with_apc             = hiera("php_apc")
    $with_dev             = hiera("php_with_dev")
    $zend_modules         = hiera("php_zend_extensions")

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
		if ($lsbdistcodename == "xenial") {
		    $srvname = "php7-fpm"
		} else {
		    $srvname = "php5-fpm"
		}
	    }
	}
    } else {
	$is_cli  = false
	$is_fpm  = false
	$srvname = false
    }
}
